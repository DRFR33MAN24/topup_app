import 'package:flutter/material.dart';
import 'package:giftme/helper/network_info.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/screens/contact_us/contact_us_screen.dart';
import 'package:giftme/view/screens/home/home_screen.dart';
import 'package:giftme/view/screens/orders/orders_screen.dart';

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
  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      const OrdersScreen(),
      const ContactUs(),
    ];

    NetworkInfo.checkConnectivity(context);
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
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
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
