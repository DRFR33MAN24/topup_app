import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/auth_provider.dart';

import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse) {
    if (apiResponse.error is! String &&
        apiResponse.error.errors[0].message == 'Unauthorized.') {
      // Move to Auth screen if not authorized

      // Provider.of<ProfileProvider>(Get.context!, listen: false)
      //     .clearHomeAddress();
      // Provider.of<ProfileProvider>(Get.context!, listen: false)
      //     .clearOfficeAddress();
      // Provider.of<AuthProvider>(Get.context!, listen: false).clearSharedData();
      // Navigator.of(Get.context!).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const AuthScreen()),
      //     (route) => false);
    } else {
      if (apiResponse.error is String) {
      } else {}
    }
  }
}
