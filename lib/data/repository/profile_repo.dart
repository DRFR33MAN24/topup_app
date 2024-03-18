import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stylizeit/data/datasource/remote/dio/dio_client.dart';
import 'package:stylizeit/data/datasource/remote/exception/api_error_handler.dart';

import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/data/model/response/user_info_model.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Permanent',
        'Home',
        'Office',
      ];
      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: addressTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.customerUri);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteUserAccount(int? customerId) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.deleteCustomerAccount}/$customerId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel,
      String pass, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (file != null) {
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    Map<String, String> fields = {};
    if (pass.isEmpty) {
      fields.addAll(<String, String>{
        '_method': 'put',
        'f_name': userInfoModel.fName!,
        'l_name': userInfoModel.lName!,
        'email': userInfoModel.email!,
        'phone': userInfoModel.phone!
      });
    } else {
      fields.addAll(<String, String>{
        '_method': 'put',
        'f_name': userInfoModel.fName!,
        'l_name': userInfoModel.lName!,
        'email': userInfoModel.email!,
        'phone': userInfoModel.phone!,
      });
    }
    request.fields.addAll(fields);
    if (kDebugMode) {
      print('========>${fields.toString()}');
    }
    http.StreamedResponse response = await request.send();
    return response;
  }
}
