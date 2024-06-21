import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giftme/helper/network_info.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/screens/contact_us/contact_us_screen.dart';
import 'package:giftme/view/screens/home/home_screen.dart';
import 'package:giftme/view/screens/orders/orders_screen.dart';
import 'package:local_auth/local_auth.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Please Authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      print(authenticated);
      if (!authenticated) {
        _authenticate();
        // exit(0);
      }

      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  AppLifecycleState? _notification;
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       //_authenticate();
  //       print("app in resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       break;
  //   }
  //   setState(() {
  //     _notification = state;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );

    _screens = [
      const HomeScreen(),
      const OrdersScreen(),
      const ContactUs(),
    ];

    NetworkInfo.checkConnectivity(context);
    _authenticate();
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_pageIndex != 0) {
            _setPage(0);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).textTheme.bodyLarge!.color,
            showUnselectedLabels: true,
            currentIndex: _pageIndex,
            type: BottomNavigationBarType.fixed,
            items: _getBottomWidget(singleVendor),
            onTap: (int index) {
              _setPage(index);
            },
          ),
          body: AbsorbPointer(
            absorbing: _authorized != 'Authorized',
            child: PageView.builder(
              controller: _pageController,
              itemCount: _screens.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens[index];
              },
            ),
          ),
        ));
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon,
        color: index == _pageIndex
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
        height: 25,
        width: 25,
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _barItemIcon(
      IconData icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon,
          color: index == _pageIndex
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
          size: 25),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> list = [];

    list.add(_barItem(Images.homeImage, getTranslated('home', context), 0));
    list.add(
        _barItemIcon(Icons.shopping_cart, getTranslated('orders', context), 1));
    list.add(_barItemIcon(Icons.payment, getTranslated('payment', context), 2));

    return list;
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
