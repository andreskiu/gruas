import 'package:injectable/injectable.dart';
import 'environment_config.dart';

@Environment(EnvironmentConfig.prod)
@Injectable(as: EnvironmentConfig)
class EnvironmentProd extends EnvironmentConfig {
  @override
  String get baseUrl => "api_url";

  @override
  String get firebaseUrl => 'url_firebase';

  @override
  String get environmentName => EnvironmentConfig.prod;
}
