import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutterappdemo/model/json.dart';
import 'package:flutterappdemo/utils/net_utils.dart';

enum DetailReduxAction {
  onLoadData,
  onAfterLoadData,
  onRefresh,
  updateModel,
  updateLoading,
}

class DetailReduxActionCreator {
  static Action onLoadData() {
    return Action(DetailReduxAction.onLoadData);
  }

  static Action updateLoading(bool loading) {
    return Action(DetailReduxAction.updateLoading, payload: loading);
  }

  static Action onRefresh() {
    return Action(DetailReduxAction.onRefresh);
  }

  static Action updateModel(dynamic model) {
    return Action(DetailReduxAction.updateModel, payload: model);
  }

  static Action onAfterLoadData(dynamic result) {
    return Action(DetailReduxAction.onAfterLoadData, payload: result);
  }
}

abstract class BaseDetailState<TState, TInput extends EncodeJson, TOut> {
  bool isLoading = true;
  bool isError = false;
  bool showToast = true;
  bool isRefresh = false;
  String cacheKey = "";
  TInput input;
  TOut model;
  String detailUrl;
  Method detailMethod = Method.GET;
  EasyRefreshController refreshController;
  bool isBody = false;

  TState clone();
}

Effect<TState> _buildDetailEffect<
    TState extends BaseDetailState<TState, TInput, TOut>,
    TInput extends EncodeJson,
    TOut>() {
  return combineEffects(<Object, Effect<TState>>{
    DetailReduxAction.onLoadData: _onLoadData,
    DetailReduxAction.onRefresh: _onRefresh,
  });
}

Effect<TState> mergeDetailEffects<
    TState extends BaseDetailState<TState, TInput, TOut>,
    TInput extends EncodeJson,
    TOut>(Effect<TState> sub) {
  return mergeEffects(_buildDetailEffect<TState, TInput, TOut>(), sub);
}

void _onLoadData<TState extends BaseDetailState>(
    Action action, Context<TState> ctx) {
  ctx.dispatch(DetailReduxActionCreator.updateLoading(true));
  NetUtils.request(
    isMask: false,
    url: ctx.state.detailUrl,
    method: ctx.state.detailMethod,
    params: ctx.state.input.toJson(),
    isBody: ctx.state.isBody,
    showToast: ctx.state.showToast,
  ).then((result) {
    if (ctx.state.isRefresh && ctx.state.refreshController != null) {
      ctx.state.refreshController.finishRefresh(success: true);
    }
    ctx.state.isRefresh = false;
    ctx.state.isError = false;
    _updateLoadingState(ctx.state, false);
    ctx.dispatch(DetailReduxActionCreator.onAfterLoadData(result));
  }).catchError((error) {
    ctx.state.isError = true;
    if (ctx.state.isRefresh && ctx.state.refreshController != null) {
      ctx.state.refreshController.finishRefresh(success: false);
    }
    ctx.state.isRefresh = false;
    ctx.dispatch(DetailReduxActionCreator.updateLoading(false));
  });
}

void _onRefresh<TState extends BaseDetailState>(
    Action action, Context<TState> ctx) {
  ctx.state.isRefresh = true;
  _onLoadData(action, ctx);
}

Reducer<TState> mergeDetailReducers<
    TState extends BaseDetailState<TState, TInput, TOut>,
    TInput extends EncodeJson,
    TOut>(Reducer<TState> sub) {
  return mergeReducers(_buildDetailReducer<TState, TInput, TOut>(), sub);
}

Reducer<TState> _buildDetailReducer<
    TState extends BaseDetailState<TState, TInput, TOut>,
    TInput extends EncodeJson,
    TOut>() {
  return asReducer(
    <Object, Reducer<TState>>{
      DetailReduxAction.updateLoading: _updateLoading,
      DetailReduxAction.updateModel: _udateModel,
    },
  );
}

TState _updateLoading<TState extends BaseDetailState>(
    TState state, Action action) {
  final TState newState = state.clone();
  _updateLoadingState(newState, action.payload);
  return newState;
}

TState _udateModel<TState extends BaseDetailState>(
    TState state, Action action) {
  final TState newState = state.clone();
  newState.model = action.payload;
  return newState;
}

void _updateLoadingState<TState extends BaseDetailState>(
    TState state, bool isLoading) {
  state.isLoading = isLoading;
}
