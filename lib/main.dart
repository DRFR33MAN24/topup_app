import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:giftme/helper/custom_delegate.dart';
import 'package:giftme/localization/app_localization.dart';
import 'package:giftme/notification/my_notification.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/category_provider.dart';
import 'package:giftme/provider/google_sign_in_provider.dart';
import 'package:giftme/provider/localization_provider.dart';
import 'package:giftme/provider/onboarding_provider.dart';
import 'package:giftme/provider/order_provider.dart';
import 'package:giftme/provider/payment_provider.dart';
import 'package:giftme/provider/profile_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/style_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/provider/tranaction_provider.dart';
import 'package:giftme/theme/dark_theme.dart';
import 'package:giftme/theme/light_theme.dart';
import 'package:giftme/util/app_constants.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/view/screens/splash/splash_screen.dart';

import 'di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // await Firebase.initializeApp();

  // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // int? orderID;
  // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //   orderID = (notificationAppLaunchDetails!.payload != null &&
  //           notificationAppLaunchDetails.payload!.isNotEmpty)
  //       ? int.parse(notificationAppLaunchDetails.payload!)
  //       : null;
  // }
  // final RemoteMessage? remoteMessage =
  //     await FirebaseMessaging.instance.getInitialMessage();
  // if (remoteMessage != null) {
  //   orderID = remoteMessage.notification?.titleLocKey != null
  //       ? int.parse(remoteMessage.notification!.titleLocKey!)
  //       : null;
  // }
  // if (kDebugMode) {
  //   print('========-notification-----$orderID----===========');
  // }
  // await MyNotification.initialize(flutterLocalNotificationsPlugin);
  // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => di.sl<StyleProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<TransactionProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<PyamentProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
    ChangeNotifierProvider(create: (context) => di.sl<GoogleSignInProvider>()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
        title: AppConstants.appName,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,

        // theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
        // // The Mandy red, dark theme.
        // darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
        // Use dark or light theme based on system setting.
        themeMode: ThemeMode.system,
        locale: Provider.of<LocalizationProvider>(context).locale,
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FallbackLocalizationDelegate()
        ],
        supportedLocales: locals,
        home: const SplashScreen());
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
