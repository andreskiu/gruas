import 'package:injectable/injectable.dart';

import 'environment_config.dart';

@Environment(EnvironmentConfig.dev)
@Injectable(as: EnvironmentConfig)
class EnvironmentDev extends EnvironmentConfig {
  @override
  String get baseUrl => "http://186.31.18.146:8084/RigelATVWS/";

  @override
  String get firebaseUrl => 'url_firebase';

  @override
  String get environmentName => EnvironmentConfig.dev;
}
