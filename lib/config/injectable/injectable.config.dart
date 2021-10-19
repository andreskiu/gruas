// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i17;

import '../../application/auth/auth_state.dart' as _i3;
import '../../application/auth/login_page_state.dart' as _i27;
import '../../application/grua/grua_service_state.dart' as _i10;
import '../../domain/auth/services/auth_service.dart' as _i21;
import '../../domain/auth/use_cases/get_user_logged_in.dart' as _i23;
import '../../domain/auth/use_cases/get_user_remembered.dart' as _i24;
import '../../domain/auth/use_cases/login.dart' as _i25;
import '../../domain/auth/use_cases/logout.dart' as _i26;
import '../../domain/grua/services/grua_service.dart' as _i15;
import '../../domain/grua/use_cases/get_services.dart' as _i18;
import '../../infrastructure/auth/repositories/demo_auth_repository.dart'
    as _i12;
import '../../infrastructure/auth/repositories/shared_preferences_auth_repository.dart'
    as _i20;
import '../../infrastructure/auth/services/auth_service.dart' as _i22;
import '../../infrastructure/auth/services/i_auth_repository.dart' as _i11;
import '../../infrastructure/auth/services/i_auth_storage_repository.dart'
    as _i19;
import '../../infrastructure/grua/repositories/grua_demo_repository.dart'
    as _i14;
import '../../infrastructure/grua/services/grua_service.dart' as _i16;
import '../../infrastructure/grua/services/interfaces/i_grua_data_repository.dart'
    as _i13;
import '../environments/environment_config.dart' as _i5;
import '../environments/environment_demo.dart' as _i6;
import '../environments/environment_dev.dart' as _i7;
import '../environments/environment_prod.dart' as _i8;
import '../environments/environment_qa.dart' as _i9;
import 'injectable.dart' as _i28;

const String _demo = 'demo';
const String _dev = 'dev';
const String _prod = 'prod';
const String _qa = 'qa';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingletonAsync<_i3.AuthState>(() => _i3.AuthState.init());
  gh.lazySingleton<_i4.Dio>(() => registerModule.dio());
  gh.factory<_i5.EnvironmentConfig>(() => _i6.EnvironmentDemo(),
      registerFor: {_demo});
  gh.factory<_i5.EnvironmentConfig>(() => _i7.EnvironmentDev(),
      registerFor: {_dev});
  gh.factory<_i5.EnvironmentConfig>(() => _i8.EnvironmentProd(),
      registerFor: {_prod});
  gh.factory<_i5.EnvironmentConfig>(() => _i9.EnvironmentTest(),
      registerFor: {_qa});
  gh.lazySingletonAsync<_i10.GruaServiceState>(
      () => _i10.GruaServiceState.init());
  gh.lazySingleton<_i11.IAuthDataRepository>(() => _i12.DemoRepository(),
      registerFor: {_demo});
  gh.lazySingleton<_i13.IGruaDataRepository>(
      () => _i14.GruaDemoRepositoryImpl(),
      registerFor: {_demo});
  gh.lazySingleton<_i15.IGruaService>(
      () => _i16.GruaServiceImpl(repository: get<_i13.IGruaDataRepository>()));
  await gh.factoryAsync<_i17.SharedPreferences>(() => registerModule.prefs,
      preResolve: true);
  gh.lazySingleton<_i18.GetServicesUseCase>(
      () => _i18.GetServicesUseCase(get<_i15.IGruaService>()));
  gh.lazySingleton<_i19.IAuthStorageRepository>(() =>
      _i20.SharedPreferencesAuthRepository(
          pref: get<_i17.SharedPreferences>()));
  gh.lazySingleton<_i21.AuthService>(() => _i22.AuthServiceImpl(
      repository: get<_i11.IAuthDataRepository>(),
      localStorage: get<_i19.IAuthStorageRepository>()));
  gh.lazySingleton<_i23.GetUserLoggedInUseCase>(
      () => _i23.GetUserLoggedInUseCase(get<_i21.AuthService>()));
  gh.lazySingleton<_i24.GetUserRememberedUseCase>(
      () => _i24.GetUserRememberedUseCase(get<_i21.AuthService>()));
  gh.lazySingleton<_i25.LoginUseCase>(
      () => _i25.LoginUseCase(get<_i21.AuthService>()));
  gh.lazySingleton<_i26.LogoutUseCase>(
      () => _i26.LogoutUseCase(get<_i21.AuthService>()));
  gh.factoryAsync<_i27.LoginPageState>(() async => _i27.LoginPageState(
      loginUseCase: get<_i25.LoginUseCase>(),
      authState: await get.getAsync<_i3.AuthState>(),
      getUserRememberedUseCase: get<_i24.GetUserRememberedUseCase>()));
  return get;
}

class _$RegisterModule extends _i28.RegisterModule {}
