import 'package:flutter/material.dart';
import 'package:stylizeit/helper/network_info.dart';
import 'package:stylizeit/provider/splash_provider.dart';

import 'package:stylizeit/localization/language_constants.dart';
import 'package:stylizeit/util/images.dart';
import 'package:stylizeit/view/screens/auth/auth_screen.dart';
import 'package:stylizeit/view/screens/home/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:stylizeit/view/screens/tools/tools_screen.dart';

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
      const ToolsScreen(),
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

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> list = [];

    list.add(_barItem(Images.homeImage, getTranslated('home', context), 0));
    list.add(_barItem(Images.tools, getTranslated('tools', context), 1));

    return list;
  }
}
