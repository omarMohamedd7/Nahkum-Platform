import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/utils/fcm_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final injector = GetIt.asNewInstance();

Future<void> initDependencies() async {
  final dio = Dio(
    BaseOptions(
      sendTimeout: const Duration(minutes: 5),
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      error: true,
      requestHeader: true,
    ),
  );

  injector.registerSingleton<Dio>(dio);

  injector.registerSingleton<DataService>(DataService(injector()));

  // Register FcmService
  injector.registerSingleton<FcmService>(FcmService());

  // Register repositories
  injector.registerLazySingleton<ClientRepo>(() => ClientRepo());
}
