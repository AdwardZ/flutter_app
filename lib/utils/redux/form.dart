import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutterappdemo/model/json.dart';

import '../net_utils.dart';

enum FormReduxAction {
  onLoadData,
  onSubmit,
  onBeforeSubmit,
  onAfterSubmit,
  updateInput,
  updateSubmiting,
}

class FormReduxActionCreator {
  static Action onSubmit() {
    return Action(FormReduxAction.onSubmit);
  }

  static Action updateSubmiting(bool submiting) {
    return Action(FormReduxAction.updateSubmiting, payload: submiting);
  }

  static Action updateInput(dynamic input) {
    return Action(FormReduxAction.updateInput, payload: input);
  }

  static Action onBeforeSubmit() {
    return Action(FormReduxAction.onBeforeSubmit);
  }

  static Action onAfterSubmit(dynamic result) {
    return Action(FormReduxAction.onAfterSubmit, payload: result);
  }
}

/**
    ..input = input
    ..submiting = submiting
    ..submitUrl = submitUrl
    ..submitMethod = submitMethod
    ..isBody = isBody
    ..formState = formState
 */
abstract class BaseFormState<TState, TInput extends EncodeJson> {
  bool submiting = false;
  bool isLoading = false;
  TInput input;
  String submitUrl;
  Method submitMethod = Method.PUT;
  bool isBody = true;
  GlobalKey<FormState> formState;

  TState clone();
}

abstract class BaseFormState1<TState, TInput extends EncodeJson, TModel>
    extends BaseFormState<TState, TInput> {
  TModel model;
}

Effect<TState> _buildFormEffect<TState extends BaseFormState<TState, TInput>,
    TInput extends EncodeJson>() {
  return combineEffects(<Object, Effect<TState>>{
    FormReduxAction.onSubmit: _onSubmit,
  });
}

Effect<TState> mergeFormEffects<TState extends BaseFormState<TState, TInput>,
    TInput extends EncodeJson>(Effect<TState> sub) {
  return mergeEffects(_buildFormEffect<TState, TInput>(), sub);
}

void _onSubmit<TState extends BaseFormState>(
    Action action, Context<TState> ctx) {
  if (ctx.state.formState != null &&
      !ctx.state.formState.currentState.validate()) return;
  ctx.dispatch(FormReduxActionCreator.updateSubmiting(true));
  ctx.dispatch(FormReduxActionCreator.onBeforeSubmit());
  NetUtils.request(
    url: ctx.state.submitUrl,
    method: ctx.state.submitMethod,
    params: ctx.state.input.toJson(),
    isBody: ctx.state.isBody,
    isMask: false,
    throwError: true,
  ).then((result) {
    ctx.dispatch(
        FormReduxActionCreator.onAfterSubmit(result == null ? false : result));
  }).whenComplete(() {
    ctx.dispatch(FormReduxActionCreator.updateSubmiting(false));
  });
}

Reducer<TState> mergeFormReducers<TState extends BaseFormState<TState, TInput>,
    TInput extends EncodeJson>(Reducer<TState> sub) {
  return mergeReducers(_buildFormReducer<TState, TInput>(), sub);
}

Reducer<TState> _buildFormReducer<TState extends BaseFormState<TState, TInput>,
    TInput extends EncodeJson>() {
  return asReducer(
    <Object, Reducer<TState>>{
      FormReduxAction.updateSubmiting: _updateSubmiting,
      FormReduxAction.updateInput: _updateInput,
    },
  );
}

TState _updateSubmiting<TState extends BaseFormState>(
    TState state, Action action) {
  final TState newState = state.clone();
  newState.submiting = action.payload;
  return newState;
}

TState _updateInput<TState extends BaseFormState>(TState state, Action action) {
  final TState newState = state.clone();
  newState.input = action.payload;
  return newState;
}
