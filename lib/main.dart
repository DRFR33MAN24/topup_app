import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/helper/custom_delegate.dart';
import 'package:stylizeit/localization/app_localization.dart';
import 'package:stylizeit/provider/auth_provider.dart';
import 'package:stylizeit/provider/google_sign_in_provider.dart';
import 'package:stylizeit/provider/localization_provider.dart';
import 'package:stylizeit/provider/onboarding_provider.dart';
import 'package:stylizeit/provider/order_provider.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/provider/splash_provider.dart';
import 'package:stylizeit/provider/style_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/theme/dark_theme.dart';
import 'package:stylizeit/theme/light_theme.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/view/screens/splash/splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'di_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => di.sl<StyleProvider>()),
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
