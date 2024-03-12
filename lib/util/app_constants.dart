import 'package:stylizeit/data/model/response/language_model.dart';

class AppConstants {
  static const String appName = 'StylizeIt';
  static const String appVersion = '14.0';
  static const String baseUrl = 'http://192.168.1.9:8000';
  static const String socketUri = 'ws://192.168.1.9:6001';
  static const String socialLoginUri = "/api/auth/social-login";
  static const String registrationUri = "/api/auth/register";
  static const String loginUri = "/api/auth/login";
  static const String tokenUri = "/api/user/cm-firebase-token";
  static const String checkEmailUri = "/api/auth/check-email";
  static const String resendEmailOtpUri = "/api/auth/resend-otp-check-email";
  static const String verifyEmailUri = "/api/auth/verify-email";
  static const String resetPasswordUri = "/api/auth/reset-password";
  static const String forgetPasswordUri = "/api/auth/forgot-password";
  static const String configUri = "/api/config/";
  static const String verifyPhoneUri = '/api/v1/auth/verify-phone';
  static const String verifyOtpUri = '/api/v1/auth/verify-otp';
  static const String checkPhoneUri = '/api/v1/auth/check-phone';
  static const String resendPhoneOtpUri = '/api/v1/auth/resend-otp-check-phone';
  static const String latestStyles = '/api/styles/styles?limit=10&&offset=';
  static const String stylesTags = '/api/styles/tags';
  static const String packages = '/api/payment/packages';

  static const String placeOrder = '/api/orders/place-order';

  static const String intro = "intro";
  static const String token = 'token';
  static const String countryCode = 'countryCode';
  static const String languageCode = 'languageCode';
  static const String langKey = 'lang';
  static const String topic = "stylizeit";
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
