import 'package:flutter/foundation.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/data/model/response/style_model.dart';
import 'package:stylizeit/data/repository/style_repo.dart';
import 'package:stylizeit/helper/api_checker.dart';

class StyleProvider extends ChangeNotifier {
  final StyleRepo? styleRepo;
  StyleProvider({required this.styleRepo});

  List<Style> _styleList = [];
  List<Style> get styleList => _styleList;
  Map<String, bool> _tagsToggleMap = Map<String, bool>();
  Map<String, bool> get tagsToggleMap => _tagsToggleMap;
  List<Tag> _tagsList = [];
  List<Tag> get tagsList => _tagsList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _pageSize = 1;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];
  List<String> get offsetList => _offsetList;

  Future<void> getStyleList(String offset, String? tag,
      {bool reload = false}) async {
    _isLoading = true;
    if (reload) {
      _offsetList = [];
      _styleList = [];
    }
    if (!_offsetList.contains(offset.toString())) {
      _offsetList.add(offset.toString());
      ApiResponse apiResponse =
          await styleRepo!.getLatestStyleList(offset, tag!);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _styleList
            .addAll(StyleModel.fromJson(apiResponse.response!.data).styles!);
        _pageSize = StyleModel.fromJson(apiResponse.response!.data).totalSize;

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

  Future<void> getTagsList({bool reload = false}) async {
    _isLoading = true;
    ApiResponse apiResponse = await styleRepo!.getTagsList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _tagsList.addAll(TagModel.fromJson(apiResponse.response!.data).tags!);

      _tagsToggleMap =
          Map.fromEntries(_tagsList.map((e) => MapEntry(e.tag!, false)));

      _isLoading = false;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;

    notifyListeners();
  }
}
