import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Page, Action;
import 'package:flutterappdemo/dirSitePage/page.dart';
import 'package:flutterappdemo/dirOnePage/page.dart';
import 'package:flutterappdemo/dirTwoPage/page.dart';
import 'package:flutterappdemo/dirThreePage/page.dart';
import 'package:flutterappdemo/utils/data_utils.dart';
import 'package:flutterappdemo/utils/net_utils.dart';
import 'uploadPage/page.dart';
import 'homePage/page.dart';
import 'login/page.dart';
import 'rulesExplain/page.dart';

Widget createApp() {
  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      'rulesExplain_page': RulesExplainPage(),
      'login': LoginPage(),
      'homePage': HomePage(),
      'dirSitePage': DirSitePage(),
      'dirOnePage': DirOnePage(),
      'dirTwoPage': DirTwoPage(),
      'dirThreePage': DirThreePage(),
      'uploadPage': UploadPage(),
    },
  );

  return MaterialApp(
    title: 'FishDemo',
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: DataUtils.getUser() != null
        ? routes.buildPage('homePage', null)
        : routes.buildPage('login', null),
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        return routes.buildPage(settings.name, settings.arguments);
      });
    },
  );
}
