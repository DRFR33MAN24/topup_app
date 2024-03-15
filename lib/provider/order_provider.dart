import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:stylizeit/data/model/response/order_model.dart';
import 'package:stylizeit/data/model/response/response_model.dart';
import 'package:stylizeit/data/repository/order_repo.dart';
import 'package:http/http.dart' as http;
import 'package:stylizeit/main.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/view/screens/style/result_screen.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepo? orderRepo;
  PusherChannelsFlutter? pusher;

  OrderProvider({required this.orderRepo});

  Order? currentOrder;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _connected = false;
  bool get connected => _connected;

  Future<ResponseModel> placeOrder(String serviceId, String token) async {
    _isLoading = true;
    notifyListeners();
//check if user have enough credits!
    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.placeOrder(serviceId, token);
    _isLoading = false;

    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];

      responseModel = ResponseModel(message, true);
      if (kDebugMode) {
        print(message);
      }

      //start socket connection to server and subscribe to order status update channel
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      _connected = false;
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }
}
