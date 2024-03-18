class ConfigModel {
  String? _aboutUs;
  String? _privacyPolicy;
  num? _currencyConversionFactor;
  String? _termsConditions;
  RefundPolicy? _refundPolicy;
  RefundPolicy? _returnPolicy;
  RefundPolicy? _cancellationPolicy;

  bool? _maintenanceMode;
  List<String>? _language;

  bool? _emailVerification;
  bool? _phoneVerification;
  String? _countryCode;

  List<SocialLogin>? _socialLogin;
  String? _forgetPasswordVerification;
  Announcement? _announcement;
  String? _version;

  PaymentMethods? _paymentMethods;

  ConfigModel(
      {String? aboutUs,
      String? privacyPolicy,
      num? currencyConversionFactor,
      String? termsConditions,
      RefundPolicy? refundPolicy,
      RefundPolicy? returnPolicy,
      RefundPolicy? cancellationPolicy,
      bool? maintenanceMode,
      List<String>? language,
      bool? emailVerification,
      bool? phoneVerification,
      String? countryCode,
      List<SocialLogin>? socialLogin,
      String? forgetPasswordVerification,
      Announcement? announcement,
      String? version,
      PaymentMethods? paymentMethods}) {
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;

    _termsConditions = termsConditions;
    if (refundPolicy != null) {
      _refundPolicy = refundPolicy;
    }
    if (returnPolicy != null) {
      _returnPolicy = returnPolicy;
    }
    if (cancellationPolicy != null) {
      _cancellationPolicy = cancellationPolicy;
    }

    _maintenanceMode = maintenanceMode;
    _language = language;

    _emailVerification = emailVerification;
    _phoneVerification = phoneVerification;
    _countryCode = countryCode;
    _socialLogin = socialLogin;
    _forgetPasswordVerification = forgetPasswordVerification;
    _announcement = announcement;
    _version = version;

    if (paymentMethods != null) {
      _paymentMethods = paymentMethods;
    }
  }

  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;
  num? get currencyConversionFactor => _currencyConversionFactor;

  String? get termsConditions => _termsConditions;
  RefundPolicy? get refundPolicy => _refundPolicy;
  RefundPolicy? get returnPolicy => _returnPolicy;
  RefundPolicy? get cancellationPolicy => _cancellationPolicy;

  bool? get maintenanceMode => _maintenanceMode;
  List<String>? get language => _language;

  bool? get emailVerification => _emailVerification;
  bool? get phoneVerification => _phoneVerification;
  String? get countryCode => _countryCode;

  List<SocialLogin>? get socialLogin => _socialLogin;
  String? get forgetPasswordVerification => _forgetPasswordVerification;
  Announcement? get announcement => _announcement;
  String? get version => _version;
  PaymentMethods? get paymentMethods => _paymentMethods;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _aboutUs = json['about_us'];
    _privacyPolicy = json['privacy_policy'];
    _currencyConversionFactor = json['currency_conversion_factor'];

    _termsConditions = json['terms_&_conditions'];
    _refundPolicy = json['refund_policy'] != null
        ? RefundPolicy.fromJson(json['refund_policy'])
        : null;
    _returnPolicy = json['return_policy'] != null
        ? RefundPolicy.fromJson(json['return_policy'])
        : null;
    _cancellationPolicy = json['cancellation_policy'] != null
        ? RefundPolicy.fromJson(json['cancellation_policy'])
        : null;

    _maintenanceMode = json['maintenance_mode'];
    _language = json['language'].cast<String>();

    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _countryCode = json['country_code'];

    if (json['social_login'] != null) {
      _socialLogin = [];
      json['social_login'].forEach((v) {
        _socialLogin!.add(SocialLogin.fromJson(v));
      });
    }
    _forgetPasswordVerification = json['forgot_password_verification'];
    _announcement = json['announcement'] != null
        ? Announcement.fromJson(json['announcement'])
        : null;

    if (json['software_version'] != null) {
      _version = json['software_version'];
    }

    _paymentMethods = json['payment_methods'] != null
        ? PaymentMethods.fromJson(json['payment_methods'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['about_us'] = _aboutUs;
    data['privacy_policy'] = _privacyPolicy;
    data["currency_conversion_factor"] = _currencyConversionFactor;

    data['terms_&_conditions'] = _termsConditions;
    if (_refundPolicy != null) {
      data['refund_policy'] = _refundPolicy!.toJson();
    }
    if (_returnPolicy != null) {
      data['return_policy'] = _returnPolicy!.toJson();
    }
    if (_cancellationPolicy != null) {
      data['cancellation_policy'] = _cancellationPolicy!.toJson();
    }

    data['maintenance_mode'] = _maintenanceMode;
    data['language'] = _language;

    data['email_verification'] = _emailVerification;
    data['phone_verification'] = _phoneVerification;
    data['country_code'] = _countryCode;

    if (_socialLogin != null) {
      data['social_login'] = _socialLogin!.map((v) => v.toJson()).toList();
    }
    data['forgot_password_verification'] = _forgetPasswordVerification;
    if (_announcement != null) {
      data['announcement'] = _announcement!.toJson();
    }
    if (_version != null) {
      data['software_version'] = _version;
    }

    if (_paymentMethods != null) {
      data['payment_methods'] = _paymentMethods!.toJson();
    }
    return data;
  }
}

class SocialLogin {
  String? _loginMedium;
  bool? _status;

  SocialLogin({String? loginMedium, bool? status}) {
    _loginMedium = loginMedium;
    _status = status;
  }

  String? get loginMedium => _loginMedium;
  bool? get status => _status;

  SocialLogin.fromJson(Map<String, dynamic> json) {
    _loginMedium = json['login_medium'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login_medium'] = _loginMedium;
    data['status'] = _status;
    return data;
  }
}

class Announcement {
  String? _status;
  String? _color;
  String? _textColor;
  String? _announcement;

  Announcement(
      {String? status,
      String? color,
      String? textColor,
      String? announcement}) {
    if (status != null) {
      _status = status;
    }
    if (color != null) {
      _color = color;
    }
    if (textColor != null) {
      _textColor = textColor;
    }
    if (announcement != null) {
      _announcement = announcement;
    }
  }

  String? get status => _status;
  String? get color => _color;
  String? get textColor => _textColor;
  String? get announcement => _announcement;
  Announcement.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _color = json['color'];
    _textColor = json['text_color'];
    _announcement = json['announcement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['color'] = _color;
    data['text_color'] = _textColor;
    data['announcement'] = _announcement;
    return data;
  }
}

class RefundPolicy {
  int? _status;
  String? _content;

  RefundPolicy({int? status, String? content}) {
    if (status != null) {
      _status = status;
    }
    if (content != null) {
      _content = content;
    }
  }

  int? get status => _status;
  String? get content => _content;

  RefundPolicy.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['content'] = _content;
    return data;
  }
}

class PaymentMethods {
  bool? _offlinePayment;
  bool? _sslCommerzPayment;
  bool? _paypal;
  bool? _stripe;
  bool? _razorPay;
  bool? _senangPay;
  bool? _paytabs;
  bool? _paystack;
  bool? _paymobAccept;
  bool? _fawryPay;
  bool? _mercadopago;
  bool? _liqpay;
  bool? _flutterwave;
  bool? _paytm;
  bool? _bkash;

  PaymentMethods(
      {bool? offlinePayment,
      bool? sslCommerzPayment,
      bool? paypal,
      bool? stripe,
      bool? razorPay,
      bool? senangPay,
      bool? paytabs,
      bool? paystack,
      bool? paymobAccept,
      bool? fawryPay,
      bool? mercadopago,
      bool? liqpay,
      bool? flutterwave,
      bool? paytm,
      bool? bkash}) {
    if (offlinePayment != null) {
      _offlinePayment = offlinePayment;
    }
    if (sslCommerzPayment != null) {
      _sslCommerzPayment = sslCommerzPayment;
    }
    if (paypal != null) {
      _paypal = paypal;
    }
    if (stripe != null) {
      _stripe = stripe;
    }
    if (razorPay != null) {
      _razorPay = razorPay;
    }
    if (senangPay != null) {
      _senangPay = senangPay;
    }
    if (paytabs != null) {
      _paytabs = paytabs;
    }
    if (paystack != null) {
      _paystack = paystack;
    }
    if (paymobAccept != null) {
      _paymobAccept = paymobAccept;
    }
    if (fawryPay != null) {
      _fawryPay = fawryPay;
    }
    if (mercadopago != null) {
      _mercadopago = mercadopago;
    }
    if (liqpay != null) {
      _liqpay = liqpay;
    }
    if (flutterwave != null) {
      _flutterwave = flutterwave;
    }
    if (paytm != null) {
      _paytm = paytm;
    }
    if (bkash != null) {
      _bkash = bkash;
    }
  }

  bool? get offlinePayment => _offlinePayment;
  bool? get sslCommerzPayment => _sslCommerzPayment;
  bool? get paypal => _paypal;
  bool? get stripe => _stripe;
  bool? get razorPay => _razorPay;
  bool? get senangPay => _senangPay;
  bool? get paytabs => _paytabs;
  bool? get paystack => _paystack;
  bool? get paymobAccept => _paymobAccept;
  bool? get fawryPay => _fawryPay;
  bool? get mercadopago => _mercadopago;
  bool? get liqpay => _liqpay;
  bool? get flutterwave => _flutterwave;
  bool? get paytm => _paytm;
  bool? get bkash => _bkash;

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    _offlinePayment = json['offline_payment'];
    _sslCommerzPayment = json['ssl_commerz_payment'];
    _paypal = json['paypal'];
    _stripe = json['stripe'];
    _razorPay = json['razor_pay'];
    _senangPay = json['senang_pay'];
    _paytabs = json['paytabs'];
    _paystack = json['paystack'];
    _paymobAccept = json['paymob_accept'];
    _fawryPay = json['fawry_pay'];
    _mercadopago = json['mercadopago'];
    _liqpay = json['liqpay'];
    _flutterwave = json['flutterwave'];
    _paytm = json['paytm'];
    _bkash = json['bkash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offline_payment'] = _offlinePayment;
    data['ssl_commerz_payment'] = _sslCommerzPayment;
    data['paypal'] = _paypal;
    data['stripe'] = _stripe;
    data['razor_pay'] = _razorPay;
    data['senang_pay'] = _senangPay;
    data['paytabs'] = _paytabs;
    data['paystack'] = _paystack;
    data['paymob_accept'] = _paymobAccept;
    data['fawry_pay'] = _fawryPay;
    data['mercadopago'] = _mercadopago;
    data['liqpay'] = _liqpay;
    data['flutterwave'] = _flutterwave;
    data['paytm'] = _paytm;
    data['bkash'] = _bkash;
    return data;
  }
}
