import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutterappdemo/model/json.dart';

import '../net_utils.dart';
import '../shared_preferences.dart';

enum ListReduxAction {
  onLoadData,
  onCallRefresh,
  onAfterLoadData,
  onNextData,
  updateData,
  updateloading,
}

class ListReduxActionCreator {
  static Action onLoadData({int page}) {
    return Action(ListReduxAction.onLoadData, payload: page);
  }

  static Action onRefreshData() {
    return Action(ListReduxAction.onLoadData, payload: 1);
  }

  static Action onCallRefresh() {
    return Action(ListReduxAction.onCallRefresh);
  }

  static Action onNextData() {
    return Action(ListReduxAction.onNextData);
  }

  static Action onAfterLoadData(dynamic result) {
    return Action(ListReduxAction.onAfterLoadData, payload: result);
  }

  static Action updateData(dynamic list) {
    return Action(ListReduxAction.updateData, payload: list);
  }

  static Action updateLoading(bool isLoading) {
    return Action(ListReduxAction.updateloading, payload: isLoading);
  }
}

abstract class BaseListState<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState> extends MutableSource {
  bool isLoading = false;
  bool isFirstLoading;
  bool isFinlish = false;
  bool isError = false;
  int refreshStatus = 0; //1=刷新中,2=加载中
  int page = 1;
  int perPage = 15;
  int total = 0;
  TInput input;
  String listUrl;
  Method listMethod = Method.PUT;
  bool isBody = true;
  List<TItemState> items = List<TItemState>();
  String itemName = 'item';
  String cacheKey;
  EasyRefreshController refreshController;

  @override
  Object getItemData(int index) {
    return this.items[index];
  }

  @override
  String getItemType(int index) {
    return this.itemName;
  }

  @override
  int get itemCount => this.items == null ? 0 : this.items.length;

  @override
  void setItemData(int index, Object data) {
    this.items[index] = data;
  }

  TState clone();
}

Effect<TState> mergeListEffects<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState>(Effect<TState> sub) {
  return mergeEffects(_buildListEffect<TState, TInput, TItemState>(), sub);
}

Effect<TState> _buildListEffect<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState>() {
  return combineEffects(<Object, Effect<TState>>{
    ListReduxAction.onLoadData: _onLoadData,
    ListReduxAction.onCallRefresh: _onCallRefresh,
    ListReduxAction.onNextData: _onNextData
  });
}

void _onNextData<TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson, TItemState>(Action action, Context<TState> ctx) {
  ctx.state.page++;
  _onLoadData(action, ctx);
}

void _onCallRefresh<TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson, TItemState>(Action action, Context<TState> ctx) {
  ctx.state.refreshStatus = 1;
  ctx.dispatch(ListReduxActionCreator.onLoadData(page: 1));
}

void _onLoadData<TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson, TItemState>(Action action, Context<TState> ctx) {
  if (ctx.state.isLoading) return;
  int page = action.payload;
  if (page != null) {
    ctx.state.page = page;
  }
  ctx.state.isError = false;
  ctx.dispatch(ListReduxActionCreator.updateLoading(true));
  var params = ctx.state.input == null
      ? Map<String, dynamic>()
      : ctx.state.input.toJson();
  params['page'] = ctx.state.page;
//  params['perPage'] = DataUtils.getUser().userType ==1? ctx.state.perPage:100000;
  params['perPage'] = ctx.state.perPage;
//  if(DataUtils.getUser().userType ==2) {
//    params['taskStatus'] = 1;
//  }
  NetUtils.request(
    url: ctx.state.listUrl,
    method: ctx.state.listMethod,
    params: params,
    isBody: ctx.state.isBody,
    isMask: false,
    throwError: true,
  ).then((result) {
    _doResult(ctx, result, true);
//     if(DataUtils.getUser().userType ==1) {
//       _doResult(ctx, result,true);
//     } else {
//       _doPromoterResult(ctx, result['records'], true);
//     }
  }).catchError((e) async {
    if (ctx.state.page == 1 &&
        ctx.state.cacheKey != null &&
        ctx.state.cacheKey.isNotEmpty) {
      //加载缓存数据
      var spUtil = await SpUtil.instance;
      var list = spUtil.getObject(ctx.state.cacheKey, def: () => []);
      _doResult(ctx, list, false);
//      if(DataUtils.getUser().userType ==1) {
//        _doResult(ctx, list,false);
//      }else{
//        _doPromoterResult(ctx, list,false);
//      }

      return;
    }
    ctx.state.isError = true;
    if (ctx.state.refreshController != null) {
      if (ctx.state.page == 1) {
        ctx.state.refreshController.resetRefreshState();
      } else {
        ctx.state.refreshController.finishLoad(success: true);
      }
    }
    ctx.dispatch(ListReduxActionCreator.updateLoading(false));
  });
}

void _doResult<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState>(Context<TState> ctx, dynamic result, bool isCache) async {
  _updateLoadingState(ctx.state, false);
  if (result == true) {
    result = [];
  }
  if (result != null) {
    if (result is List) {
      var list = result;
      //缓存数据
      if (isCache &&
          ctx.state.cacheKey != null &&
          ctx.state.cacheKey.isNotEmpty) {
        var spUtil = await SpUtil.instance;
        spUtil.setObject(ctx.state.cacheKey, list);
      }
      ctx.state.isFinlish = true;
      if (ctx.state.refreshStatus == 1) {
        ctx.state.refreshStatus = 0;
        ctx.state.refreshController.finishRefresh(success: true);
      }
      ctx.dispatch(ListReduxActionCreator.onAfterLoadData(list));
    } else if (result.containsKey('total')) {
      ctx.state.total = result['total'];
      if (ctx.state.items.length >= ctx.state.total) {
        ctx.state.isFinlish = true;
      }
      //缓存数据
      if (isCache &&
          ctx.state.page == 1 &&
          ctx.state.cacheKey != null &&
          ctx.state.cacheKey.isNotEmpty) {
        var spUtil = await SpUtil.instance;
        spUtil.setObject(ctx.state.cacheKey, result);
      }
      if (ctx.state.page == 1 && ctx.state.refreshController != null) {
        ctx.state.refreshController.finishRefresh(success: true);
        if (ctx.state.isFinlish == true) {
          ctx.state.refreshController.finishLoad(success: true, noMore: true);
        } else {
          ctx.state.refreshController.resetLoadState();
        }
      } else if (ctx.state.page > 1 && ctx.state.refreshController != null) {
        ctx.state.refreshController
            .finishLoad(success: true, noMore: ctx.state.isFinlish);
      }
      ctx.dispatch(ListReduxActionCreator.onAfterLoadData(result['records']));
    } else {
      if (ctx.state.refreshStatus == 1) {
        ctx.state.refreshStatus = 0;
        ctx.state.refreshController.finishRefresh(success: true);
      }
      ctx.dispatch(ListReduxActionCreator.onAfterLoadData(result));
    }
  }
}

//void _doPromoterResult<
//TState extends BaseListState<TState, TInput, TItemState>,
//TInput extends EncodeJson,
//TItemState>(Context<TState> ctx, dynamic result, bool isCache) async {
//  _updateLoadingState(ctx.state, false);
//  if (result==true){
//    result=[];
//  }
//  if (result != null) {
//    if ( result is List) {
//      var list = result;
//      //缓存数据
//      if (isCache && ctx.state.cacheKey != null && ctx.state.cacheKey.isNotEmpty) {
//        var spUtil = await SpUtil.instance;
//        spUtil.setObject(ctx.state.cacheKey, list);
//      }
//      ctx.dispatch(ListReduxActionCreator.onAfterLoadData(list));
//    } else if (result.containsKey('total')) {
//      ctx.state.total = result['total'];
//      if (ctx.state.items.length >= ctx.state.total) {
//        ctx.state.isFinlish = true;
//      }
//
//      //缓存数据
//      if (isCache && ctx.state.page == 1 &&
//          ctx.state.cacheKey != null &&
//          ctx.state.cacheKey.isNotEmpty) {
//        var spUtil = await SpUtil.instance;
//        spUtil.setObject(ctx.state.cacheKey, result);
//      }
//      if (ctx.state.page == 1 && ctx.state.refreshController != null) {
//        ctx.state.refreshController.finishRefresh(success: true);
//        if (ctx.state.isFinlish = true) {
//          ctx.state.refreshController.finishLoad(success: true, noMore: true);
//        } else {
//          ctx.state.refreshController.resetLoadState();
//        }
//      } else if (ctx.state.page > 1 && ctx.state.refreshController != null) {
//        ctx.state.refreshController
//            .finishLoad(success: true, noMore: ctx.state.isFinlish);
//      }
//      ctx.dispatch(ListReduxActionCreator.onAfterLoadData(result['records']));
//    }
//  }
//}
Reducer<TState> mergeListReducers<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState>(Reducer<TState> sub) {
  return mergeReducers(_buildListReducer<TState, TInput, TItemState>(), sub);
}

Reducer<TState> _buildListReducer<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState>() {
  return asReducer(
    <Object, Reducer<TState>>{
      ListReduxAction.updateloading: _updateLoading,
      ListReduxAction.updateData: _updateData
    },
  );
}

TState _updateData<TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson, TItemState>(TState state, Action action) {
  final TState newState = state.clone();
  List<TItemState> items = action.payload as List<TItemState>;
  if (state.page == 1) {
    newState.items.clear();
  }
  for (int i = 0; i < items.length; i++) {
    newState.items.add(items[i]);
  }
  return newState;
}

TState _updateLoading<TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson, TItemState>(TState state, Action action) {
  final TState newState = state.clone();
  _updateLoadingState(newState, action.payload ?? false);
  return newState;
}

void _updateLoadingState<
    TState extends BaseListState<TState, TInput, TItemState>,
    TInput extends EncodeJson,
    TItemState>(TState state, bool isLoading) {
  state.isLoading = isLoading;
  if (state.isLoading && state.isFirstLoading == null) {
    state.isFirstLoading = true;
  } else if (state.isFirstLoading == null) {
    state.isFirstLoading = true;
  } else if (state.isFirstLoading) {
    state.isFirstLoading = false;
  }
}
