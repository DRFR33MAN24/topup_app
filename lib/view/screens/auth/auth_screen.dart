// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:giftme/localization/language_constants.dart';
// import 'package:giftme/provider/auth_provider.dart';
// import 'package:giftme/util/dimensions.dart';
// import 'package:giftme/view/basewidgets/button/custom_button.dart';
// import 'package:giftme/view/basewidgets/textfield/custom_textfield.dart';
// import 'package:giftme/view/screens/auth/widget/code_picker_widget.dart';
// import 'package:giftme/view/screens/auth/widget/social_login_widget.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({Key? key}) : super(key: key);

//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final FocusNode _phoneFocus = FocusNode();

//   String? _countryDialCode = "+880";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // SocialLoginWidget(),
//           Container(
//             margin: const EdgeInsets.only(
//                 left: Dimensions.marginSizeDefault,
//                 right: Dimensions.marginSizeDefault,
//                 top: Dimensions.marginSizeSmall),
//             child: Row(children: [
//               CodePickerWidget(
//                 onChanged: (CountryCode countryCode) {
//                   _countryDialCode = countryCode.dialCode;
//                 },
//                 initialSelection: _countryDialCode,
//                 favorite: [_countryDialCode!],
//                 showDropDownButton: true,
//                 padding: EdgeInsets.zero,
//                 showFlagMain: true,
//                 textStyle: TextStyle(
//                     color: Theme.of(context).textTheme.displayLarge!.color),
//               ),
//               Expanded(
//                   child: CustomTextField(
//                 hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
//                 controller: _phoneController,
//                 focusNode: _phoneFocus,
//                 isPhoneNumber: true,
//                 textInputAction: TextInputAction.next,
//                 textInputType: TextInputType.phone,
//               )),
//             ]),
//           ),

//           Container(
//             margin: const EdgeInsets.only(
//                 left: Dimensions.marginSizeLarge,
//                 right: Dimensions.marginSizeLarge,
//                 bottom: Dimensions.marginSizeLarge,
//                 top: Dimensions.marginSizeLarge),
//             child: Provider.of<AuthProvider>(context).isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   )
//                 : CustomButton(
//                     onTap: null, buttonText: getTranslated('SIGN_UP', context)),
//           ),
//         ],
//       ),
//     ));
//   }
// }
