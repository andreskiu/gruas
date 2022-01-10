// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i19;

import '../../application/auth/auth_state.dart' as _i3;
import '../../application/auth/login_page_state.dart' as _i37;
import '../../application/grua/grua_service_state.dart' as _i10;
import '../../domain/auth/services/auth_service.dart' as _i28;
import '../../domain/auth/use_cases/get_user_logged_in.dart' as _i33;
import '../../domain/auth/use_cases/get_user_remembered.dart' as _i34;
import '../../domain/auth/use_cases/login.dart' as _i35;
import '../../domain/auth/use_cases/logout.dart' as _i36;
import '../../domain/grua/services/grua_service.dart' as _i22;
import '../../domain/grua/use_cases/get_evidence_types.dart' as _i30;
import '../../domain/grua/use_cases/get_service_routes.dart' as _i31;
import '../../domain/grua/use_cases/get_services.dart' as _i32;
import '../../domain/grua/use_cases/save_evidence.dart' as _i25;
import '../../domain/grua/use_cases/save_location.dart' as _i26;
import '../../domain/grua/use_cases/save_service.dart' as _i27;
import '../../infrastructure/auth/repositories/demo_auth_repository.dart'
    as _i12;
import '../../infrastructure/auth/repositories/server_auth_repository.dart'
    as _i13;
import '../../infrastructure/auth/repositories/shared_preferences_auth_repository.dart'
    as _i21;
import '../../infrastructure/auth/services/auth_service.dart' as _i29;
import '../../infrastructure/auth/services/i_auth_repository.dart' as _i11;
import '../../infrastructure/auth/services/i_auth_storage_repository.dart'
    as _i20;
import '../../infrastructure/grua/repositories/grua_demo_repository.dart'
    as _i16;
import '../../infrastructure/grua/repositories/grua_firebase_repository.dart'
    as _i17;
import '../../infrastructure/grua/repositories/grua_memory_repo.dart' as _i15;
import '../../infrastructure/grua/repositories/grua_server_repository.dart'
    as _i18;
import '../../infrastructure/grua/services/grua_service.dart' as _i23;
import '../../infrastructure/grua/services/interfaces/i_grua_data_repository.dart'
    as _i14;
import '../environments/environment_config.dart' as _i5;
import '../environments/environment_demo.dart' as _i6;
import '../environments/environment_dev.dart' as _i7;
import '../environments/environment_prod.dart' as _i8;
import '../environments/environment_qa.dart' as _i9;
import 'injectable.dart' as _i24;

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
  gh.lazySingleton<_i11.IAuthDataRepository>(() => _i13.DemoRepository(),
      registerFor: {_dev, _qa, _prod});
  gh.lazySingleton<_i14.ICacheService>(() => _i15.GruaMemoryRepository(),
      registerFor: {_dev, _qa, _prod});
  gh.lazySingleton<_i14.IFirebaseService>(() => _i16.GruaDemoRepositoryImpl(),
      registerFor: {_demo});
  gh.lazySingleton<_i14.IFirebaseService>(() => _i17.GruaDemoRepositoryImpl(),
      registerFor: {_dev, _qa, _prod});
  gh.lazySingleton<_i14.IServerService>(() => _i18.GruaServerRepository(),
      registerFor: {_dev, _qa, _prod});
  await gh.factoryAsync<_i19.SharedPreferences>(() => registerModule.prefs,
      preResolve: true);
  gh.lazySingleton<_i20.IAuthStorageRepository>(() =>
      _i21.SharedPreferencesAuthRepository(
          pref: get<_i19.SharedPreferences>()));
  gh.lazySingleton<_i22.IGruaService>(() => _i23.GruaServiceImpl(
      firebase: get<_i14.IFirebaseService>(),
      server: get<_i14.IServerService>(),
      cache: get<_i14.ICacheService>()));
  gh.factory<_i4.InterceptorsWrapper>(
      () => _i24.AppInterceptorsWrapper(
          authRepo: get<_i20.IAuthStorageRepository>()),
      registerFor: {_dev, _qa, _prod});
  gh.lazySingleton<_i25.SaveEvidenceUseCase>(
      () => _i25.SaveEvidenceUseCase(get<_i22.IGruaService>()));
  gh.lazySingleton<_i26.SaveLocationUseCase>(
      () => _i26.SaveLocationUseCase(get<_i22.IGruaService>()));
  gh.lazySingleton<_i27.SaveServicesUseCase>(
      () => _i27.SaveServicesUseCase(get<_i22.IGruaService>()));
  gh.lazySingleton<_i28.AuthService>(() => _i29.AuthServiceImpl(
      repository: get<_i11.IAuthDataRepository>(),
      localStorage: get<_i20.IAuthStorageRepository>()));
  gh.lazySingleton<_i30.GetEvidenceTypesUseCase>(
      () => _i30.GetEvidenceTypesUseCase(get<_i22.IGruaService>()));
  gh.lazySingleton<_i31.GetServiceRouteUseCase>(
      () => _i31.GetServiceRouteUseCase(get<_i22.IGruaService>()));
  gh.lazySingleton<_i32.GetServicesUseCase>(
      () => _i32.GetServicesUseCase(get<_i22.IGruaService>()));
  gh.lazySingleton<_i33.GetUserLoggedInUseCase>(
      () => _i33.GetUserLoggedInUseCase(get<_i28.AuthService>()));
  gh.lazySingleton<_i34.GetUserRememberedUseCase>(
      () => _i34.GetUserRememberedUseCase(get<_i28.AuthService>()));
  gh.lazySingleton<_i35.LoginUseCase>(
      () => _i35.LoginUseCase(get<_i28.AuthService>()));
  gh.lazySingleton<_i36.LogoutUseCase>(
      () => _i36.LogoutUseCase(get<_i28.AuthService>()));
  gh.factory<_i37.LoginPageState>(() => _i37.LoginPageState(
      loginUseCase: get<_i35.LoginUseCase>(),
      getUserRememberedUseCase: get<_i34.GetUserRememberedUseCase>()));
  return get;
}

class _$RegisterModule extends _i24.RegisterModule {}
