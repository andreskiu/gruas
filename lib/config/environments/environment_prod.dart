import 'package:injectable/injectable.dart';
import 'environment_config.dart';

@Environment(EnvironmentConfig.prod)
@Injectable(as: EnvironmentConfig)
class EnvironmentProd extends EnvironmentConfig {
  @override
  String get baseUrl => "http://186.31.100.133:8080/RigelATVWS/";

  @override
  String get firebaseUrl => 'url_firebase';

  @override
  String get environmentName => EnvironmentConfig.prod;
}
