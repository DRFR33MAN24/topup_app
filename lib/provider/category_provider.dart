import 'package:flutter/foundation.dart';
import 'package:stylizeit/data/model/response/base/api_response.dart';
import 'package:stylizeit/data/model/response/category_model.dart' as cat;
import 'package:stylizeit/data/repository/category_repo.dart';
import 'package:stylizeit/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo? categoryRepo;
  CategoryProvider({required this.categoryRepo});

  List<cat.Category> _categoryList = [];
  List<cat.Category> get categoryList => _categoryList;
  Map<cat.Tag, bool> _tagsToggleMap = Map<cat.Tag, bool>();
  Map<cat.Tag, bool> get tagsToggleMap => _tagsToggleMap;
  List<cat.Tag> _tagsList = [];
  List<cat.Tag> get tagsList => _tagsList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];
  List<String> get offsetList => _offsetList;

  Future<void> getCategoryList(String offset, String? tag, String? search,
      {bool reload = false}) async {
    _isLoading = true;
    if (reload) {
      _offsetList = [];
      _categoryList = [];
    }
    if (!_offsetList.contains(offset.toString())) {
      _offsetList.add(offset.toString());
      ApiResponse apiResponse =
          await categoryRepo!.getLatestCategoryList(offset, tag!, search!);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _categoryList.addAll(
            cat.CategoryModel.fromJson(apiResponse.response!.data).categories!);
        _pageSize =
            cat.CategoryModel.fromJson(apiResponse.response!.data).totalSize;

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
    ApiResponse apiResponse = await categoryRepo!.getTagsList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _tagsList.addAll(cat.TagModel.fromJson(apiResponse.response!.data).tags!);

      _tagsToggleMap =
          Map.fromEntries(_tagsList.map((e) => MapEntry(e, false)));

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
