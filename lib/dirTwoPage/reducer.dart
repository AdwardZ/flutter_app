import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DirTwoState> buildReducer() {
  return asReducer(
    <Object, Reducer<DirTwoState>>{
      DirTwoAction.action: _onAction,
      DirTwoAction.submitSuccess: _submitSuccess,
    },
  );
}

DirTwoState _onAction(DirTwoState state, Action action) {
  final DirTwoState newState = state.clone();
  return newState;
}

DirTwoState _submitSuccess(DirTwoState state, Action action) {
  final DirTwoState newState = state.clone();
  newState.dirOne.approveStatus = 2;
  return newState;
}
