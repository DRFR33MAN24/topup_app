import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:stylizeit/data/datasource/remote/dio/dio_client.dart';
import 'package:stylizeit/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:stylizeit/data/repository/auth_repo.dart';
import 'package:stylizeit/data/repository/category_repo.dart';
import 'package:stylizeit/data/repository/onboarding_repo.dart';
import 'package:stylizeit/data/repository/order_repo.dart';
import 'package:stylizeit/data/repository/payment_repo.dart';
import 'package:stylizeit/data/repository/splash_repo.dart';
import 'package:stylizeit/data/repository/style_repo.dart';
import 'package:stylizeit/helper/network_info.dart';
import 'package:stylizeit/provider/auth_provider.dart';
import 'package:stylizeit/provider/category_provider.dart';
import 'package:stylizeit/provider/google_sign_in_provider.dart';
import 'package:stylizeit/provider/localization_provider.dart';
import 'package:stylizeit/provider/onboarding_provider.dart';
import 'package:stylizeit/provider/order_provider.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/provider/splash_provider.dart';
import 'package:stylizeit/provider/style_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';

import 'package:stylizeit/util/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository

  sl.registerLazySingleton(() => StyleRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PaymentRepo(dioClient: sl()));

  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));

  sl.registerLazySingleton(() => OrderRepo(dioClient: sl()));

  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));

  // Provider

  sl.registerFactory(() => StyleProvider(styleRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));

  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));

  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => PyamentProvider(paymentRepo: sl()));

  sl.registerFactory(() => SplashProvider(splashRepo: sl()));

  sl.registerFactory(
      () => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => GoogleSignInProvider());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}
