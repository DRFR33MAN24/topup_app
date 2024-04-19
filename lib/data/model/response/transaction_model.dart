class TransactionModel {
  int? _totalSize;
  int? _limit;
  int? _offset;
  List<Transaction>? _transactions;

  TransactionModel(
      {int? totalSize,
      int? limit,
      int? offset,
      List<Transaction>? transactions}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _transactions = transactions;
  }

  int? get totalSize => _totalSize;
  int? get limit => _limit;
  int? get offset => _offset;
  List<Transaction>? get transactions => _transactions;

  TransactionModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['transactions'] != null) {
      _transactions = [];
      json['transactions'].forEach((v) {
        _transactions!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_transactions != null) {
      data['transactions'] = _transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  int? _id;
  int? _userId;

  String? _trx_type;
  String? _amount;
  String? _charge;
  String? _remarks;
  String? _currency;
  String? _trx_id;
  String? _createdAt;
  String? _updatedAt;

  Transaction(
      {int? id,
      int? userId,
      String? trx_type,
      String? amount,
      String? charge,
      String? remarks,
      String? currency,
      String? trx_id,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _userId = userId;
    _trx_type = trx_type;
    _amount = amount;
    _charge = charge;
    _remarks = remarks;
    _currency = currency;
    _trx_id = trx_id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get userId => _userId;
  String? get trx_type => _trx_type;
  String? get amount => _amount;
  String? get charge => _charge;
  String? get remarks => _remarks;
  String? get currency => _currency;
  String? get trx_id => _trx_id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Transaction.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _userId = json["user_id"];
    _trx_type = json["trx_type"];
    _amount = num.parse(json["amount"].toString()).toStringAsFixed(3);
    _charge = json["charge"];
    _remarks = json["remarks"];
    _currency = json['currency'];
    _trx_id = json["trx_id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["user_id"] = userId;
    data["trx_type"] = trx_type;
    data["amount"] = amount;
    data["charge"] = charge;
    data["remarks"] = remarks;
    data['currency'] = currency;
    data["trx_id"] = trx_id;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
