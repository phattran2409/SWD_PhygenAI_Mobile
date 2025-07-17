import 'package:phygen/core/di/Auth_Injector.dart';
import 'package:phygen/core/di/CoreInjector.dart';
import 'package:phygen/core/di/Dependency_Injector.dart';
import 'package:phygen/core/di/Upload_injector.dart';

Future<void> init() async {
  DependencyManager.addInjector(CoreInjector());
  DependencyManager.addInjector(AuthInjector());
  DependencyManager.addInjector(UploadInjector());
  await DependencyManager.init();
}

final sl = DependencyManager.sl;
