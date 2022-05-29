import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DirSitePage extends Page<DirSiteState, Map<String, dynamic>> {
  DirSitePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DirSiteState>(
              adapter: null, slots: <String, Dependent<DirSiteState>>{}),
          middleware: <Middleware<DirSiteState>>[],
        );
}
