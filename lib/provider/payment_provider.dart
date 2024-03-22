import 'package:flutter/material.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/data/model/response/payment_model.dart';
import 'package:giftme/data/repository/payment_repo.dart';
import 'package:giftme/helper/api_checker.dart';

class PyamentProvider extends ChangeNotifier {
  final PaymentRepo? paymentRepo;
  PyamentProvider({required this.paymentRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Package> _packages = [];
  List<Package> get packages => _packages;

  int _paymentMethodIndex = 0;
  int get paymentMethodIndex => _paymentMethodIndex;

  Future<void> getPackages({bool reload = false}) async {
    _isLoading = true;
    ApiResponse apiResponse = await paymentRepo!.getPackages();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _packages
          .addAll(PackageModel.fromJson(apiResponse.response!.data).packages!);

      _isLoading = false;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }
}
