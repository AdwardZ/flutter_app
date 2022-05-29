import 'package:get_it/get_it.dart';
import './TelAndSmsService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(TelAndSmsService());
}
