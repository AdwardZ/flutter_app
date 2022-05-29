import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DirThreeState> buildReducer() {
  return asReducer(
    <Object, Reducer<DirThreeState>>{
      DirThreeAction.action: _onAction,
      DirThreeAction.submitSuccess: _submitSuccess,
    },
  );
}

DirThreeState _onAction(
    DirThreeState state, Action action) {
  final DirThreeState newState = state.clone();
  return newState;
}

DirThreeState _submitSuccess(
    DirThreeState state, Action action) {
  final DirThreeState newState = state.clone();
  newState.dirTwo.approveStatus = 2;
  return newState;
}
