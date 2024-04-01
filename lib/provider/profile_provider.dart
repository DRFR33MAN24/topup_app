import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/data/model/response/response_model.dart';
import 'package:giftme/data/model/response/user_info_model.dart';
import 'package:giftme/data/repository/profile_repo.dart';
import 'package:giftme/helper/api_checker.dart';
import 'package:giftme/main.dart';
import 'package:provider/provider.dart';

import '../view/screens/auth/widget/mobile_verify_screen.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo? profileRepo;
  ProfileProvider({required this.profileRepo});

  final List<String> _addressTypeList = [];
  String? _addressType = '';
  UserInfoModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  bool? _hasData;
  bool _isHomeAddress = true;
  String? _addAddressErrorText;
  double? _balance;
  double? get balance => _balance;

  List<String> get addressTypeList => _addressTypeList;
  String? get addressType => _addressType;
  UserInfoModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;

  bool? get hasData => _hasData;
  bool get isHomeAddress => _isHomeAddress;
  String? get addAddressErrorText => _addAddressErrorText;

  void setAddAddressErrorText(String errorText) {
    _addAddressErrorText = errorText;
    // notifyListeners();
  }

  void updateAddressCondition(bool value) {
    _isHomeAddress = value;
    notifyListeners();
  }

  bool _checkHomeAddress = false;
  bool get checkHomeAddress => _checkHomeAddress;

  bool _checkOfficeAddress = false;
  bool get checkOfficeAddress => _checkOfficeAddress;

  void setHomeAddress() {
    _checkHomeAddress = true;
    _checkOfficeAddress = false;
    notifyListeners();
  }

  void setOfficeAddress() {
    _checkHomeAddress = false;
    _checkOfficeAddress = true;
    notifyListeners();
  }

  updateCountryCode(String value) {
    _addressType = value;
    notifyListeners();
  }

  Future<String> getUserInfo(BuildContext context) async {
    String userID = '-1';
    ApiResponse apiResponse = await profileRepo!.getUserInfo();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      userID = _userInfoModel!.id.toString();
      _balance = _userInfoModel!.walletBalance;
      if (_userInfoModel!.status == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text("Account Banned"),
          backgroundColor: Colors.red,
        ));
        Provider.of<AuthProvider>(context, listen: false)
            .clearSharedData()
            .then((condition) {
          print("logged out");
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MobileVerificationScreen("")),
            (route) => false);
      }
    } else {
      Provider.of<AuthProvider>(context, listen: false)
          .clearSharedData()
          .then((condition) {
        print("logged out");
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const MobileVerificationScreen("")),
          (route) => false);
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return userID;
  }

  Future<ApiResponse> deleteCustomerAccount(
      BuildContext context, int? customerId) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo!.deleteUserAccount(customerId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String message = map['message'];
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(Get.context!).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  void initAddressTypeList(BuildContext context) async {
    if (_addressTypeList.isEmpty) {
      ApiResponse apiResponse = await profileRepo!.getAddressTypeList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _addressTypeList.clear();
        _addressTypeList.addAll(apiResponse.response!.data);
        _addressType = apiResponse.response!.data[0];
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    }
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel,
      String pass, File? file, String token) async {
    print("dbg ${updateUserModel}");
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo!.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      if (kDebugMode) {
        print(message);
      }
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }
}
