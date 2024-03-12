class OrderModel {
  int? _id;
  int? _userId;
  int? _styleId;
  String? _uploadedImg;
  String? _orderStatus;
  String? _createdAt;
  String? _updatedAt;

  OrderModel(
      {int? id,
      int? userId,
      int? styleId,
      String? uploadedImg,
      String? orderStatus,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _userId = userId;
    _styleId = styleId;
    _uploadedImg = uploadedImg;
    _orderStatus = orderStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get styleId => _styleId;
  String? get uploadedImg => _uploadedImg;
  String? get orderStatus => _orderStatus;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _userId = json["user_id"];
    _styleId = json["style_id"];
    _uploadedImg = json["uploaded_img"];
    _orderStatus = json["order_status"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["user_id"] = userId;
    data["style_id"] = styleId;
    data["uploaded_img"] = uploadedImg;
    data["order_status"] = orderStatus;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
