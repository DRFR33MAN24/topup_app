import 'dart:convert';

class OrderModel {
  int? _totalSize;
  int? _limit;
  int? _offset;
  List<Order>? _orders;

  OrderModel({int? totalSize, int? limit, int? offset, List<Order>? orders}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _orders = orders;
  }

  int? get totalSize => _totalSize;
  int? get limit => _limit;
  int? get offset => _offset;
  List<Order>? get orders => _orders;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_orders != null) {
      data['orders'] = _orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? _id;
  int? _userId;
  int? _categoryId;
  int? _serviceId;
  int? _qty;
  String? _uploadedImg;

  String? _price;
  String? _status;
  String? _description;
  String? _reason;
  String? _orderStatus;
  String? _createdAt;
  String? _updatedAt;

  Order(
      {int? id,
      int? userId,
      int? categoryId,
      int? serviceId,
      int? qty,
      String? uploadedImg,
      String? price,
      String? status,
      String? description,
      String? reason,
      String? orderStatus,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _userId = userId;
    _categoryId = categoryId;
    _serviceId = serviceId;
    _qty = qty;
    _uploadedImg = uploadedImg;
    _orderStatus = orderStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get categoryId => _categoryId;
  int? get serviceId => _serviceId;
  int? get qty => _qty;
  String? get uploadedImg => _uploadedImg;

  String? get price => _price;
  String? get status => _status;
  String? get description => _description;
  String? get reason => _reason;
  String? get orderStatus => _orderStatus;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Order.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _userId = json["user_id"];
    _categoryId = json["category_id"];
    _serviceId = json["service_id"];
    _qty = json["quantity"];
    _uploadedImg = json["uploaded_img"];
    _price = json["price"].toString();
    _status = json["status"];
    _description = json["status_description"];
    _reason = json["reason"];
    _orderStatus = json["order_status"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["user_id"] = userId;
    data["category_id"] = categoryId;
    data["service_id"] = serviceId;
    data["quantity"] = qty;
    data["uploaded_img"] = uploadedImg;
    data["price"] = price;
    data["status"] = status;
    data["status_description"] = description;
    data["reason"] = reason;
    data["order_status"] = orderStatus;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
