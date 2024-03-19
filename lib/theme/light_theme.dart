import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

// ThemeData light = FlexThemeData.light(
//   scheme: FlexScheme.deepBlue,
//   useMaterial3: false,
// );
// Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
ThemeData light = FlexThemeData.light(
  scheme: FlexScheme.blue,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 10,
  appBarStyle: FlexAppBarStyle.background,
  bottomAppBarElevation: 1.0,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendTextTheme: true,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    thickBorderWidth: 2.0,
    elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    toggleButtonsBorderSchemeColor: SchemeColor.primary,
    segmentedButtonSchemeColor: SchemeColor.primary,
    segmentedButtonBorderSchemeColor: SchemeColor.primary,
    unselectedToggleIsColored: true,
    sliderValueTinted: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorBackgroundAlpha: 15,
    inputDecoratorRadius: 10.0,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    chipRadius: 10.0,
    popupMenuRadius: 6.0,
    popupMenuElevation: 6.0,
    useInputDecoratorThemeInDialogs: true,
    appBarScrolledUnderElevation: 8.0,
    drawerWidth: 280.0,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6.0,
    menuElevation: 6.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarIndicatorOpacity: 1.00,
    navigationBarElevation: 2.0,
    navigationBarHeight: 70.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1.00,
  ),
  keyColors: const FlexKeyColors(
    useTertiary: true,
    keepPrimary: true,
    keepTertiary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

