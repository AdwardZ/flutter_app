import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UploadState> buildReducer() {
  return asReducer(
    <Object, Reducer<UploadState>>{
      UploadAction.action: _onAction,
    },
  );
}

UploadState _onAction(UploadState state, Action action) {
  final UploadState newState = state.clone();
  return newState;
}
