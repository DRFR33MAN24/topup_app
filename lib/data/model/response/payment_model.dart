class PackageModel {
  List<Package>? _packages;

  PackageModel({List<Package>? packages}) {
    _packages = packages;
  }

  List<Package>? get packages => _packages;

  PackageModel.fromJson(Map<String, dynamic> json) {
    if (json['packages'] != null) {
      _packages = [];
      json['packages'].forEach((v) {
        _packages!.add(Package.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_packages != null) {
      data['packages'] = _packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Package {
  int? _id;

  String? _name;
  int? _amount;
  String? _createdAt;
  String? _updatedAt;

  Package(
      {int? id,
      String? name,
      int? amount,
      String? updated_at,
      String? created_at}) {
    _id = id;

    _name = name;
    _amount = amount;
    _createdAt = created_at;
    _updatedAt = updated_at;
  }

  String? get name => _name;
  int? get amount => _amount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  int? get id => _id;

  Package.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _amount = json['amount'];

    _id = json["id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;

    data['name'] = _name;
    data['amount'] = _amount;
    data["created_at"] = _createdAt;
    data["updated_at"] = _updatedAt;
    return data;
  }
}
