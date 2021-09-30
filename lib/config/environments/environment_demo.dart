import 'package:injectable/injectable.dart';
import 'environment_config.dart';

@Environment(EnvironmentConfig.demo)
@Injectable(as: EnvironmentConfig)
class EnvironmentDemo extends EnvironmentConfig {
  @override
  String get baseUrl => 'no_url_for_this_environment';

  @override
  String get firebaseUrl => "use_with_local_data";

  @override
  String get environmentName => EnvironmentConfig.demo;
}
