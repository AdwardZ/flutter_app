import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DirOnePage extends Page<DirOneState, Map<String, dynamic>> {
  DirOnePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DirOneState>(
              adapter: null, slots: <String, Dependent<DirOneState>>{}),
          middleware: <Middleware<DirOneState>>[],
        );
}
