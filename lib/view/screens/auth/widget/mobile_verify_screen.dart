import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:giftme/view/basewidgets/show_custom_snakbar.dart';
import 'package:giftme/view/basewidgets/textfield/custom_textfield.dart';
import 'package:giftme/view/screens/Html/privacy_policy_screen.dart';
import 'package:giftme/view/screens/Html/terms_conditions.dart';
import 'package:provider/provider.dart';
import 'code_picker_widget.dart';
import 'otp_verification_screen.dart';

class MobileVerificationScreen extends StatefulWidget {
  final String tempToken;
  const MobileVerificationScreen(this.tempToken, {Key? key}) : super(key: key);

  @override
  MobileVerificationScreenState createState() =>
      MobileVerificationScreenState();
}

class MobileVerificationScreenState extends State<MobileVerificationScreen> {
  TextEditingController? _numberController;
  final FocusNode _numberFocus = FocusNode();
  String? _countryDialCode = '+961';

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode!)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final number = ModalRoute.of(context)!.settings.arguments ?? '';
    _numberController!.text = number as String;
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          child: Image.asset(Images.login,
                              matchTextDirection: true,
                              height: MediaQuery.of(context).size.height / 4.5),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Center(
                          child: Text(
                        getTranslated('mobile_verification', context)!,
                      )),
                      const SizedBox(height: Dimensions.paddingSizeThirtyFive),
                      Text(
                        getTranslated('mobile_number', context)!,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          CodePickerWidget(
                            onChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            initialSelection: _countryDialCode,
                            favorite: [_countryDialCode!],
                            showDropDownButton: true,
                            padding: EdgeInsets.zero,
                            showFlagMain: true,
                            textStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color),
                            countryFilter: ['LB'],
                          ),
                          Expanded(
                              child: CustomTextField(
                            hintText: getTranslated('number_hint', context),
                            controller: _numberController,
                            focusNode: _numberFocus,
                            isPhoneNumber: true,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.phone,
                          )),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      const SizedBox(height: 12),
                      !authProvider.isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                              buttonText: getTranslated('continue', context),
                              onTap: () async {
                                String controllerNum =
                                    _numberController!.text.trim();
                                if (controllerNum.startsWith('0')) {
                                  controllerNum = controllerNum.substring(1);
                                }

                                String number =
                                    _countryDialCode! + controllerNum;
                                String numberChk = controllerNum;

                                if (numberChk.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_phone_number', context),
                                      context);
                                }
                                //  else if (!validateMobile(number)) {
                                //   showCustomSnackBar(
                                //       'enter valid phone number', context);
                                // }
                                else {
                                  authProvider
                                      .checkPhone(number, widget.tempToken)
                                      .then((value) async {
                                    if (value.isSuccess) {
                                      authProvider.updatePhone(number);
                                      if (value.message == 'active') {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  VerificationScreen(
                                                widget.tempToken,
                                                number,
                                              ),
                                              settings: RouteSettings(
                                                arguments: number,
                                              ),
                                            ),
                                            (route) => false);
                                      }
                                    } else {
                                      final snackBar = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        content: Text(getTranslated(
                                            'phone_number_already_exist',
                                            context)!),
                                        backgroundColor: Colors.red,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const PrivacyPolicyScreen()));
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Privacy Policy"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const TermsAndConditonsScreen()));
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Terms and Conditions"),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  bool validateMobile(String value) {
    String pattern = r'(^(?:[+]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
