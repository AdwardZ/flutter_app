import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DirThreePage
    extends Page<DirThreeState, Map<String, dynamic>> {
  DirThreePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DirThreeState>(
              adapter: null,
              slots: <String, Dependent<DirThreeState>>{}),
          middleware: <Middleware<DirThreeState>>[],
        );
}
