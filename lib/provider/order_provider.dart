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

  OrderModel? currentOrder;
  Uint8List? _uploadedImg;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _img = '';
  String get img => _img;
  String _progress = 'connecting...';
  String get progress => _progress;
  bool _connected = false;
  bool get connected => _connected;
  String? currentOrderStatus = 'Pending';

  Future<ResponseModel> placeOrder(
      String styleId, Uint8List? file, String token) async {
    _uploadedImg = file;
    _isLoading = true;
    notifyListeners();
//check if user have enough credits!
    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.placeOrder(styleId, file, token);
    _isLoading = false;
    _progress = 'connecting...';
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];

      responseModel = ResponseModel(message, true);
      if (kDebugMode) {
        print(message);
      }

      //start socket connection to server and subscribe to order status update channel
      pusher = PusherChannelsFlutter.getInstance();
      try {
        await pusher!.init(
            apiKey: '64b07dcf28d5d209109e', cluster: 'eu', logToConsole: true);
        await pusher!.connect();

        //  await pusher!.subscribe(channelName: "order_stats", onEvent: onStats);
        await pusher!
            .subscribe(channelName: "order_progress", onEvent: onProgress);
        await pusher!
            .subscribe(channelName: "order_complete", onEvent: onComplete);
      } catch (e) {
        print('dbg ${e}');
        _connected = false;
      }
      _connected = true;
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
  //create a function to recieve socket messages and update the ui
  // pull the last picture from the server using http when receiving order completed through
  // the socket and terminate connection.

  dynamic onProgress(dynamic event) {
    if (kDebugMode) {
      print('dbg progress ${event.data}');
    }
    dynamic data = jsonDecode(event.data);
    if (data['progress'] != null) {
      // if (data['progress'].runtimeType is int) {
      //   _progress = data['progress'].toString();
      // } else {
      _progress = data['progress'];
      // }
    }

    notifyListeners();
  }
  //   dynamic onStats(dynamic event) {
  //   if (kDebugMode) {
  //     print('dbg ${event.data}');
  //   }
  //   if (event.data.runtimeType is String) {
  //     dynamic data = jsonDecode(event.data);
  //     print(data);

  //     pusher!.disconnect();
  //     _connected = false;
  //   }

  //   notifyListeners();
  // }
  dynamic onComplete(dynamic event) {
    if (kDebugMode) {
      print('dbg complete ${event.data}');
    }

    dynamic data = jsonDecode(event.data);
    if (data['img'] != null) {
      pusher!.disconnect();
      _connected = false;
      _img = data['img'];
      notifyListeners();

      Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ResultScreen(img_after: _img, img_before: _uploadedImg!)));
    }
  }
}
