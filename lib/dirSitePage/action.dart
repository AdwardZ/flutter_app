import 'package:fish_redux/fish_redux.dart';
import 'package:flutterappdemo/model/home_res_model.dart';

//TODO replace with your own action
enum DirSiteAction {
  action,
  requestMore,
  goDirOnePage,
  back,
  searchSite,
  initDate,
  requestAll
}

class DirSiteActionCreator {
  ///好像没做什么事情
  static Action onAction() {
    return const Action(DirSiteAction.action);
  }

  ///加载更多
  static Action requestMore() {
    return const Action(DirSiteAction.requestMore);
  }

  ///返回
  static Action back() {
    return const Action(DirSiteAction.back);
  }

  ///初始化数据
  static Action initDate() {
    return const Action(DirSiteAction.initDate);
  }

  ///跳转下一个页面
  static Action goDirOnePage(AppSite appSite) {
    return Action(DirSiteAction.goDirOnePage, payload: appSite);
  }

  ///搜索站点
  static Action searchSite(String siteId) {
    return Action(DirSiteAction.searchSite, payload: siteId);
  }

  ///请求所有站点
  static Action requestAll(List<AppSite> appSites) {
    return Action(DirSiteAction.requestAll, payload: appSites);
  }
}
