class UserInfoModel {
  int? id;
  int? status;
  String? name;
  String? method;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  double? walletBalance;
  double? loyaltyPoint;
  int? isReseller;

  UserInfoModel({
    this.id,
    this.status,
    this.name,
    this.method,
    this.fName,
    this.lName,
    this.phone,
    this.image,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.walletBalance,
    this.loyaltyPoint,
    this.isReseller,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    name = json['name'];
    method = json['_method'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['balance'] != null) {
      walletBalance = num.parse(json['balance']).toDouble();
    }
    if (json['loyalty_point'] != null) {
      loyaltyPoint = json['loyalty_point'].toDouble();
    } else {
      // walletBalance = 0.0;
    }

    isReseller = json['is_reseller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['name'] = name;
    data['_method'] = method;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['image'] = image;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['balance'] = walletBalance;
    data['loyalty_point'] = loyaltyPoint;
    data['is_reseller'] = isReseller;
    return data;
  }
}
