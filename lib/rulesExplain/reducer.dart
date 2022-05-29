import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RulesExplainState> buildReducer() {
  return asReducer(
    <Object, Reducer<RulesExplainState>>{
      RulesExplainAction.action: _onAction,
    },
  );
}

RulesExplainState _onAction(RulesExplainState state, Action action) {
  final RulesExplainState newState = state.clone();
  return newState;
}
