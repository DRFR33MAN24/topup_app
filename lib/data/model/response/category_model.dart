import 'dart:convert';

class CategoryModel {
  int? _totalSize;
  int? _limit;
  int? _offset;
  List<Category>? _categories;

  CategoryModel(
      {int? totalSize, int? limit, int? offset, List<Category>? categories}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _categories = categories;
  }

  int? get totalSize => _totalSize;
  int? get limit => _limit;
  int? get offset => _offset;
  List<Category>? get categories => _categories;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['categories'] != null) {
      _categories = [];
      json['categories'].forEach((v) {
        _categories!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_categories != null) {
      data['categories'] = _categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? _id;
  String? _title;
  String? _description;
  String? _type;
  String? _image;
  String? _status;
  List<Tag>? _tags;
  List<Service>? _services;

  String? _createdAt;
  String? _updatedAt;

  Category({
    int? id,
    String? title,
    String? description,
    String? type,
    String? image,
    List<Tag>? tags,
    List<Service>? services,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _type = type;
    _image = image;
    _status = status;
    _tags = tags;
    _services = services;

    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }
  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get type => _type;
  String? get image => _image;
  String? get status => _status;

  List<Tag>? get tags => _tags;
  List<Service>? get services => _services;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _title = json["category_title"];
    _description = json["category_description"];
    _type = json["category_type"];
    _image = json["image"];
    _status = json["status"];

    if (json['tags'] != null) {
      _tags = [];
      try {
        json['tags'].forEach((v) {
          _tags!.add(Tag.fromJson(v));
        });
      } catch (e) {
        jsonDecode(json['tags']).forEach((v) {
          _tags!.add(Tag.fromJson(v));
        });
      }
    }

    if (json['services'] != null) {
      _services = [];
      try {
        json['services'].forEach((v) {
          _services!.add(Service.fromJson(v));
        });
      } catch (e) {
        jsonDecode(json['services']).forEach((v) {
          _services!.add(Service.fromJson(v));
        });
      }
    }

    _createdAt = json["created_at"];
    _updatedAt = json["updated_att"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["title"] = _title;
    data["description"] = _description;
    data["type"] = _type;
    data["image"] = _image;
    data["status"] = _status;

    if (_tags != null) {
      data['tags'] = _tags!.map((v) => v.toJson()).toList();
    }
    if (_services != null) {
      data['services'] = _services!.map((v) => v.toJson()).toList();
    }
    data["created_at"] = _createdAt;
    data["updated_at"] = _updatedAt;

    return data;
  }
}

class TagModel {
  List<Tag>? _tags;

  TagModel({List<Tag>? tags}) {
    _tags = tags;
  }

  List<Tag>? get tags => _tags;

  TagModel.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags!.add(Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_tags != null) {
      data['tags'] = _tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tag {
  int? _id;

  String? _tag;
  String? _image;
  String? _createdAt;
  String? _updatedAt;

  Tag(
      {int? id,
      int? categoryId,
      String? tag,
      String? image,
      String? updated_at,
      String? created_at}) {
    _id = id;

    _tag = tag;
    _image = image;
    _createdAt = created_at;
    _updatedAt = updated_at;
  }

  String? get tag => _tag;
  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  int? get id => _id;

  Tag.fromJson(Map<String, dynamic> json) {
    _tag = json['tag'];
    _image = json['image'];

    _id = json["id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;

    data['tag'] = _tag;
    data['image'] = _image;
    data["created_at"] = _createdAt;
    data["updated_at"] = _updatedAt;
    return data;
  }
}

class ServiceModel {
  List<Service>? _services;

  ServiceModel({List<Service>? services}) {
    _services = services;
  }

  List<Service>? get services => _services;

  ServiceModel.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      _services = [];
      json['services'].forEach((v) {
        _services!.add(Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_services != null) {
      data['services'] = _services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? _id;
  int? _status;
  int? _min_amount;
  int? _max_amount;
  int? _category_id;
  String? _image;

  String? _title;
  String? _link;
  String? _price;
  String? _reseller_price;
  String? _description;
  String? _type;
  List<String>? _params;
  String? _createdAt;
  String? _updatedAt;

  Service(
      {int? id,
      int? status,
      int? min_amount,
      int? max_amount,
      int? categoryId,
      String? image,
      String? title,
      String? link,
      List<String>? params,
      String? price,
      String? reseller_price,
      String? description,
      String? type,
      String? updated_at,
      String? created_at}) {
    _id = id;
    _status = status;
    _min_amount = min_amount;
    _max_amount = max_amount;
    _category_id = categoryId;

    _image = image;

    _title = title;
    _link = link;
    _params = params;
    _price = price;
    _reseller_price = reseller_price;
    _description = description;
    _type = type;
    _createdAt = created_at;
    _updatedAt = updated_at;
  }

  String? get title => _title;
  String? get image => _image;
  String? get link => _link;
  List<String>? get params => _params;
  String? get price => _price;
  String? get reseller_price => _reseller_price;
  String? get type => _type;
  String? get description => _description;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  int? get id => _id;
  int? get status => _status;

  int? get min_amount => _min_amount;
  int? get max_amount => _max_amount;
  int? get categoryId => _category_id;

  Service.fromJson(Map<String, dynamic> json) {
    _title = json['service_title'];
    _link = json['link'];

    if (json['custom_fields'] != null) {
      _params = json['custom_fields'].toString().split(',');
    } else {
      _params = [];
    }
    _price = num.parse(json["price"].toString()).toStringAsFixed(2);
    _reseller_price =
        num.parse(json["reseller_price"].toString()).toStringAsFixed(2);

    _description = json['description'];
    _type = json['service_type'];
    _image = json['image'];

    _id = json["id"];
    _status = json["service_status"];
    _min_amount = json['min_amount'];
    _max_amount = json['max_amount'];
    _category_id = json["category_id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["status"] = _status;
    data['min_amount'] = _min_amount;
    data['max_amount'] = _max_amount;
    data["category_id"] = _category_id;
    data["image"] = _image;

    data['title'] = _title;
    data["link"] = _link;
    data["params"] = _params;
    data["price"] = _price;
    data["reseller_price"] = _reseller_price;
    data["description"] = _description;
    data["service_type"] = _type;
    data["created_at"] = _createdAt;
    data["updated_at"] = _updatedAt;
    return data;
  }
}
