import 'package:giftme/data/model/response/language_model.dart';

class AppConstants {
  static const String appName = 'GiftMe';
  static const String appVersion = '14.0';
  static const String baseUrl = 'http://192.168.1.9:8000';
  static const String socketUri = 'ws://192.168.1.9:6001';
  static const String categories_url = '/assets/uploads/categories/';
  static const String socialLoginUri = "/api/auth/social-login";
  static const String registrationUri = "/api/auth/register";
  static const String loginUri = "/api/auth/login";
  static const String tokenUri = "/api/customer/cm-firebase-token";
  static const String checkEmailUri = "/api/auth/check-email";
  static const String resendEmailOtpUri = "/api/auth/resend-otp-check-email";
  static const String verifyEmailUri = "/api/auth/verify-email";
  static const String resetPasswordUri = "/api/auth/reset-password";
  static const String forgetPasswordUri = "/api/auth/forgot-password";
  static const String configUri = "/api/config/";
  static const String verifyPhoneUri = '/api/auth/verify-phone';
  static const String verifyOtpUri = '/api/auth/verify-otp';
  static const String checkPhoneUri = '/api/auth/check-phone';
  static const String resendPhoneOtpUri = '/api/v1/auth/resend-otp-check-phone';
  static const String latestStyles = '/api/styles/styles?limit=10&&offset=';
  static const String transaction =
      '/api/transactions/transactions?limit=10&&offset=';
  static const String stylesTags = '/api/styles/tags';

  static const String customerUri = '/api/customer/info';
  static const String deleteCustomerAccount = '/api/customer/account-delete';
  static const String updateProfileUri = '/api/customer/update-profile';

  static const String latestCategories = '/api/categories/categories?limit=10';
  static const String latestOrders = '/api/orders/orders?limit=10';
  static const String notificationUri = '/api/notifications';
  static const String categoriesTags = '/api/categories/tags';
  static const String packages = '/api/payment/packages';

  static const String placeOrder = '/api/orders/place-order';
  static const String placeTransferOrder = '/api/orders/place-transfer-order';

  static const String intro = "intro";
  static const String token = 'token';
  static const String countryCode = 'countryCode';
  static const String languageCode = 'languageCode';
  static const String langKey = 'lang';
  static const String topic = "giftme";
  static const String user = "user";
  static const String userPassword = "user_password";
  static const String userEmail = "user_email";
  static const String theme = 'theme';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: '',
        languageName: 'Arabic',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}
