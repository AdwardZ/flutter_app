import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum RulesExplainAction { action }

class RulesExplainActionCreator {
  static Action onAction() {
    return const Action(RulesExplainAction.action);
  }
}
