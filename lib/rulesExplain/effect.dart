import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<RulesExplainState> buildEffect() {
  return combineEffects(<Object, Effect<RulesExplainState>>{
    RulesExplainAction.action: _onAction,
  });
}

void _onAction(Action action, Context<RulesExplainState> ctx) {}
