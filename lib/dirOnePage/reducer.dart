import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DirOneState> buildReducer() {
  return asReducer(
    <Object, Reducer<DirOneState>>{
      DirOneAction.action: _onAction,
      DirOneAction.submitSuccess: _submitSuccess,
    },
  );
}

DirOneState _onAction(DirOneState state, Action action) {
  final DirOneState newState = state.clone();
  return newState;
}

DirOneState _submitSuccess(DirOneState state, Action action) {
  final DirOneState newState = state.clone();
  newState.appSite.approveStatus = 2;
  return newState;
}
