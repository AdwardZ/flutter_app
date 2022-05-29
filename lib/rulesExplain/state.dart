import 'package:fish_redux/fish_redux.dart';

class RulesExplainState implements Cloneable<RulesExplainState> {
  @override
  RulesExplainState clone() {
    return RulesExplainState();
  }
}

RulesExplainState initState(Map<String, dynamic> args) {
  return RulesExplainState();
}
