import 'package:flutter/foundation.dart';
import 'package:giftme/data/model/response/base/api_response.dart';
import 'package:giftme/data/model/response/transaction_model.dart';
import 'package:giftme/data/repository/transaction_repo.dart';
import 'package:giftme/helper/api_checker.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepo? transactionRepo;
  TransactionProvider({required this.transactionRepo});

  List<Transaction> _transactionList = [];
  List<Transaction> get transactionList => _transactionList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _pageSize = 1;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];
  List<String> get offsetList => _offsetList;

  Future<void> getTransactionList(String offset, String date,
      {bool reload = false}) async {
    _isLoading = true;
    if (reload) {
      _offsetList = [];
      _transactionList = [];
    }
    if (!_offsetList.contains(offset.toString())) {
      _offsetList.add(offset.toString());
      ApiResponse apiResponse =
          await transactionRepo!.getTransactionList(offset, date);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _transactionList.addAll(
            TransactionModel.fromJson(apiResponse.response!.data)
                .transactions!);
        _pageSize =
            TransactionModel.fromJson(apiResponse.response!.data).totalSize;

        _isLoading = false;
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;

    notifyListeners();
  }
}
