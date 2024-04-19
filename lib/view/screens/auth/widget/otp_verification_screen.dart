import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/profile_provider.dart';
import 'package:giftme/util/color_resources.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:giftme/view/basewidgets/show_custom_snakbar.dart';
import 'package:giftme/view/screens/dashboard/dashboard_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String tempToken;
  final String mobileNumber;

  const VerificationScreen(this.tempToken, this.mobileNumber, {Key? key})
      : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer? _timer;
  int? _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = Provider.of<AuthProvider>(context, listen: false).resendTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  route(bool isRoute, String? token) async {
    if (isRoute) {
      if (token != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text("phone verify error"),
            backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text("phone verify error"),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (_seconds! / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 55),
                      Image.asset(
                        Images.login,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          '${getTranslated('please_enter_4_digit_code', context)}\n${widget.mobileNumber}',
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 39, vertical: 35),
                        child: PinCodeTextField(
                          length: 4,
                          autoFocus: true,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor: Colors.white,
                            inactiveFillColor:
                                ColorResources.getSearchBg(context),
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor:
                                ColorResources.getSearchBg(context),
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      if (_seconds! <= 0)
                        Column(
                          children: [
                            Center(
                                child: Text(
                              getTranslated(
                                  'i_didnt_receive_the_code', context)!,
                            )),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .checkPhone(widget.mobileNumber,
                                            widget.tempToken,
                                            fromResend: true)
                                        .then((value) {
                                      if (value.isSuccess) {
                                        _startTimer();
                                        showCustomSnackBar(
                                            'Resent code successful', context,
                                            isError: false);
                                      } else {
                                        showCustomSnackBar(
                                            value.message, context);
                                      }
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    getTranslated('resend_code', context)!,
                                    style: robotoBold.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_seconds! > 0)
                        Text(
                            '${getTranslated('resend_code', context)} ${getTranslated('after', context)} ${_seconds! > 0 ? '$minutesStr:${_seconds! % 60}' : ''} ${'Sec'}'),
                      const SizedBox(height: 48),
                      authProvider.isEnableVerificationCode
                          ? !authProvider.isPhoneNumberVerificationButtonLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge),
                                  child: CustomButton(
                                    buttonText:
                                        getTranslated('verify', context),
                                    onTap: () {
                                      // bool phoneVerification =
                                      //     Provider.of<SplashProvider>(context,
                                      //                 listen: false)
                                      //             .configModel!
                                      //             .forgetPasswordVerification ==
                                      //         'phone';
                                      // if (phoneVerification &&
                                      //     widget.fromForgetPassword) {
                                      //   Provider.of<AuthProvider>(context,
                                      //           listen: false)
                                      //       .verifyOtp(widget.mobileNumber)
                                      //       .then((value) {
                                      //     if (value.isSuccess) {
                                      //       // Navigator.pushAndRemoveUntil(
                                      //       //     context,
                                      //       //     MaterialPageRoute(
                                      //       //         builder: (_) =>
                                      //       //             ResetPasswordWidget(
                                      //       //                 mobileNumber: widget
                                      //       //                     .mobileNumber,
                                      //       //                 otp: authProvider
                                      //       //                     .verificationCode)
                                      //       //                    )
                                      //       //                    ,
                                      //       //     (route) => false);
                                      //     } else {
                                      //       ScaffoldMessenger.of(context)
                                      //           .showSnackBar(SnackBar(        behavior: SnackBarBehavior.floating,

                                      //         content: Text(getTranslated(
                                      //             'input_valid_otp', context)!),
                                      //         backgroundColor: Colors.red,
                                      //       ));
                                      //     }
                                      //   });
                                      // }
                                      {
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .verifyPhone(widget.mobileNumber,
                                                widget.tempToken, route)
                                            .then((value) async {
                                          if (value.isSuccess) {
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //   behavior:
                                            //       SnackBarBehavior.floating,
                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius:
                                            //         BorderRadius.circular(24),
                                            //   ),
                                            //   content: Text(getTranslated(
                                            //       'sign_up_successfully_now_login',
                                            //       context)!),
                                            //   backgroundColor: Colors.green,
                                            // ));
                                            await Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .getUserInfo(context);

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const DashboardScreen()),
                                                (route) => false);
                                          } else {
                                            showCustomSnackBar(
                                                value.message, context);
                                          }
                                        });

                                        //  else {
                                        //   Provider.of<AuthProvider>(context,
                                        //           listen: false)
                                        //       .verifyEmail(widget.email!,
                                        //           widget.tempToken)
                                        //       .then((value) {
                                        //     if (value.isSuccess) {
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(SnackBar(        behavior: SnackBarBehavior.floating,

                                        //         content: Text(getTranslated(
                                        //             'sign_up_successfully_now_login',
                                        //             context)!),
                                        //         backgroundColor: Colors.green,
                                        //       ));
                                        //       Navigator.pushAndRemoveUntil(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //               builder: (_) =>
                                        //                   const AuthScreen()),
                                        //           (route) => false);
                                        //     } else {
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(SnackBar(        behavior: SnackBarBehavior.floating,

                                        //               content:
                                        //                   Text(value.message!),
                                        //               backgroundColor:
                                        //                   Colors.red));
                                        //     }
                                        //   });
                                        // }
                                      }
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
