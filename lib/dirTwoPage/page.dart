import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DirTwoPage extends Page<DirTwoState, Map<String, dynamic>> {
  DirTwoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DirTwoState>(
              adapter: null, slots: <String, Dependent<DirTwoState>>{}),
          middleware: <Middleware<DirTwoState>>[],
        );
}
