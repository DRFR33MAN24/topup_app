import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:giftme/data/repository/auth_repo.dart';
import 'package:giftme/data/repository/category_repo.dart';
import 'package:giftme/data/repository/notification_repo.dart';
import 'package:giftme/data/repository/onboarding_repo.dart';
import 'package:giftme/data/repository/order_repo.dart';
import 'package:giftme/data/repository/payment_repo.dart';
import 'package:giftme/data/repository/profile_repo.dart';
import 'package:giftme/data/repository/splash_repo.dart';
import 'package:giftme/data/repository/style_repo.dart';
import 'package:giftme/data/repository/transaction_repo.dart';
import 'package:giftme/helper/network_info.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/category_provider.dart';

import 'package:giftme/provider/localization_provider.dart';
import 'package:giftme/provider/onboarding_provider.dart';
import 'package:giftme/provider/order_provider.dart';
import 'package:giftme/provider/payment_provider.dart';
import 'package:giftme/provider/printing_provider.dart';
import 'package:giftme/provider/profile_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/style_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/provider/tranaction_provider.dart';

import 'package:giftme/util/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/notification_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository

  sl.registerLazySingleton(() => StyleRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => TransactionRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => PaymentRepo(dioClient: sl()));

  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));

  sl.registerLazySingleton(() => OrderRepo(dioClient: sl()));

  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => StyleProvider(styleRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => TransactionProvider(transactionRepo: sl()));

  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));

  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => PyamentProvider(paymentRepo: sl()));

  sl.registerFactory(() => SplashProvider(splashRepo: sl()));

  sl.registerFactory(
      () => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => PrintingProvider(sharedPreferences: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}
