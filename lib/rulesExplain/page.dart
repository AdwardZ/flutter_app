import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class RulesExplainPage extends Page<RulesExplainState, Map<String, dynamic>> {
  RulesExplainPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RulesExplainState>(
              adapter: null, slots: <String, Dependent<RulesExplainState>>{}),
          middleware: <Middleware<RulesExplainState>>[],
        );
}
