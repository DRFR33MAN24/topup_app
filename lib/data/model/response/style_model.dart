import 'dart:convert';

class StyleModel {
  int? _totalSize;
  int? _limit;
  int? _offset;
  List<Style>? _styles;

  StyleModel({int? totalSize, int? limit, int? offset, List<Style>? styles}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _styles = styles;
  }

  int? get totalSize => _totalSize;
  int? get limit => _limit;
  int? get offset => _offset;
  List<Style>? get styles => _styles;

  StyleModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['styles'] != null) {
      _styles = [];
      json['styles'].forEach((v) {
        _styles!.add(Style.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_styles != null) {
      data['styles'] = _styles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Style {
  int? _id;
  String? _name;
  String? _details;
  String? _img_before;
  String? _img_after;
  List<Tag>? _tags;
  int? _credits;
  List<Rating>? _rating;
  String? _createdAt;
  String? _updatedAt;

  Style({
    int? id,
    String? name,
    String? details,
    String? img_before,
    String? img_after,
    List<Tag>? tags,
    int? credits,
    List<Rating>? rating,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _details = details;
    _img_after = img_after;
    _img_before = img_before;
    _tags = tags;
    _credits = credits;
    _rating = rating;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }
  int? get id => _id;
  String? get name => _name;
  String? get details => _details;
  String? get img_after => _img_after;
  String? get img_before => _img_before;

  int? get credits => _credits;
  List<Rating>? get rating => _rating;
  List<Tag>? get tags => _tags;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Style.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _name = json["name"];
    _details = json["details"];
    _img_after = json["img_after"];
    _img_before = json["img_before"];

    _credits = json["credits"];

    if (json['rating'] != null) {
      _rating = [];
      try {
        json['rating'].forEach((v) {
          _rating!.add(Rating.fromJson(v));
        });
      } catch (e) {
        jsonDecode(json['rating']).forEach((v) {
          _rating!.add(Rating.fromJson(v));
        });
      }
    }
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

    _createdAt = json["created_at"];
    _updatedAt = json["updated_att"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["name"] = _name;
    data["details"] = _details;
    data["img_before"] = _img_before;
    data["img_after"] = _img_after;

    data["credits"] = _credits;
    if (_rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }
    if (_tags != null) {
      data['tags'] = _tags!.map((v) => v.toJson()).toList();
    }
    data["created_at"] = _createdAt;
    data["updated_at"] = _updatedAt;

    return data;
  }
}

class Rating {
  String? _average;
  int? _styleId;

  Rating({String? average, int? styleId}) {
    _average = average;
    _styleId = styleId;
  }

  String? get average => _average;
  int? get styleId => _styleId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'].toString();
    _styleId = json['style_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = _average;
    data['style_id'] = _styleId;
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
  String? _createdAt;
  String? _updatedAt;

  Tag(
      {int? id,
      int? styleId,
      String? tag,
      String? updated_at,
      String? created_at}) {
    _id = id;

    _tag = tag;
    _createdAt = created_at;
    _updatedAt = updated_at;
  }

  String? get tag => _tag;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  int? get id => _id;

  Tag.fromJson(Map<String, dynamic> json) {
    _tag = json['tag'];

    _id = json["id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;

    data['tag'] = _tag;
    data["created_at"] = _createdAt;
    data["updated_at"] = _updatedAt;
    return data;
  }
}
