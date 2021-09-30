import 'environment_var.dart';

abstract class EnvironmentConfig implements EnvironmentVar {
  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: EnvironmentConfig.demo,
  );
  static const String prod = 'prod';
  static const String dev = 'dev';
  static const String qa = 'qa';
  static const String demo = 'demo';
}
