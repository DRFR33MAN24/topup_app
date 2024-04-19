import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/profile_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/color_resources.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/basewidgets/no_internet_screen.dart';
import 'package:giftme/view/screens/auth/widget/mobile_verify_screen.dart';
//import 'package:giftme/view/screens/auth/auth_screen.dart';
import 'package:giftme/view/screens/dashboard/dashboard_screen.dart';
import 'package:giftme/view/screens/maintenance/maintenance_screen.dart';
import 'package:giftme/view/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)!
                : getTranslated('connected', context)!,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initSharedPrefData();
        Timer(const Duration(seconds: 1), () {
          if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .maintenanceMode!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const MaintenanceScreen()));
          } else {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false)
                  .updateToken(context);
              Provider.of<ProfileProvider>(context, listen: false)
                  .getUserInfo(context);

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardScreen()));
            } else {
              if (Provider.of<SplashProvider>(context, listen: false)
                  .showIntro()!) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => OnBoardingScreen(
                          indicatorColor: ColorResources.grey,
                          selectedIndicatorColor:
                              Theme.of(context).primaryColor,
                        )));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const MobileVerificationScreen("")));
                // builder: (BuildContext context) =>
                //     const DashboardScreen()));
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Image.asset(
              Images.logo_giftme,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            )
          // ? Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //       Container(
          //         width: MediaQuery.of(context).size.width,
          //         height: MediaQuery.of(context).size.height,
          //         // color: Provider.of<ThemeProvider>(context).darkTheme
          //         //     ? Colors.black
          //         //     : ColorResources.getPrimary(context),
          //         // child: CustomPaint(
          //         //   painter: SplashPainter(),
          //         // ),
          //       ),
          //       Center(
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Image.asset(
          //               Images.logo_giftme,
          //               height: 250.0,
          //               fit: BoxFit.scaleDown,
          //               width: 250.0,
          //             ),
          //             // SvgPicture.asset(
          //             //   Images.splashScreenLogo,
          //             //   height: 200.0,
          //             //   fit: BoxFit.scaleDown,
          //             //   width: 200.0,
          //             // )
          //           ],
          //         ),
          //       ),
          //     ],
          //   )
          : const NoInternetOrDataScreen(
              isNoInternet: true, child: SplashScreen()),
    );
  }
}
