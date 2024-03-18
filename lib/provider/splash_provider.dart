import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/data/model/response/config_model.dart';
import 'package:stylizeit/data/repository/splash_repo.dart';
import 'package:stylizeit/helper/api_checker.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;

  bool _hasConnection = true;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _onOff = true;
  bool get onOff => _onOff;

  String _currentCurrency = "USD";
  String get currentCurrency => _currentCurrency;

  ConfigModel? get configModel => _configModel;

  bool get hasConnection => _hasConnection;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> initConfig(BuildContext context) async {
    _hasConnection = true;
    ApiResponse apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      isSuccess = true;
    } else {
      isSuccess = false;
      ApiChecker.checkApi(apiResponse);
      if (apiResponse.error.toString() ==
          'Connection to API server failed due to internet connection') {
        _hasConnection = false;
      }
    }
    notifyListeners();
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void initSharedPrefData() {
    splashRepo!.initSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  bool? showIntro() {
    return splashRepo!.showIntro();
  }

  void disableIntro() {
    splashRepo!.disableIntro();
  }

  void changeAnnouncementOnOff(bool on) {
    _onOff = !_onOff;
    notifyListeners();
  }

  void changeCurrency(String currency) {
    _currentCurrency = currency;
    notifyListeners();
  }
}
