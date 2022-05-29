import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UploadPage extends Page<UploadState, Map<String, dynamic>> {
  UploadPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<UploadState>(
              adapter: null, slots: <String, Dependent<UploadState>>{}),
          middleware: <Middleware<UploadState>>[],
        );
}
