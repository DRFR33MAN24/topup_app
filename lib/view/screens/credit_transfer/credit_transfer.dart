import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/order_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/view/basewidgets/animated_custom_dialog.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:giftme/view/basewidgets/order_confirmation_dialog.dart';
import 'package:giftme/view/basewidgets/textfield/custom_textfield.dart';
import 'package:giftme/view/screens/auth/widget/code_picker_widget.dart';
import 'package:giftme/view/screens/home/home_screen.dart';

class CreditTransfer extends StatefulWidget {
  const CreditTransfer({Key? key}) : super(key: key);

  @override
  _CreditTransferState createState() => _CreditTransferState();
}

class _CreditTransferState extends State<CreditTransfer> {
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController? _numberController;

  String? _countryDialCode = '+961';
  @override
  void initState() {
    // TODO: implement initState
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text('Credit Transfer',
                  style: robotoRegular.copyWith(
                      fontSize: 20, color: Theme.of(context).cardColor)),
            ]),
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
          body:
              Consumer<OrderProvider>(builder: (context, orderProvider, child) {
            return Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  BalanceWidget(),
                  SizedBox(
                    height: 15,
                  ),
                  Row(children: [
                    // CodePickerWidget(
                    //   onChanged: (CountryCode countryCode) {
                    //     _countryDialCode = countryCode.dialCode;
                    //   },
                    //   initialSelection: _countryDialCode,
                    //   favorite: [_countryDialCode!],
                    //   showDropDownButton: true,
                    //   padding: EdgeInsets.zero,
                    //   showFlagMain: true,
                    //   textStyle: TextStyle(
                    //       color:
                    //           Theme.of(context).textTheme.displayLarge!.color),
                    // ),
                    Expanded(
                        child: CustomTextField(
                      hintText: getTranslated('number_hint', context),
                      controller: _numberController,
                      isPhoneNumber: true,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                    )),
                    GestureDetector(
                      onTap: () async {
                        final PhoneContact contact =
                            await FlutterContactPicker.pickPhoneContact();
                        if (contact.phoneNumber!.number != null) {
                          _numberController!.text =
                              contact.phoneNumber!.number!;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        color: Theme.of(context).canvasColor,
                        child: Icon(
                          Icons.contacts,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: "Quantity",
                    controller: amount,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  !orderProvider.isLoading
                      ? CustomButton(
                          buttonText: "Send",
                          onTap: () {
                            showAnimatedDialog(
                                context,
                                OrderConfirmationDialog(
                                    details:
                                        "Do you really want to submit this order",
                                    onConfirm: this.placeOrder));
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor)))
                ],
              ),
            );
          }),
        ));
  }

  placeOrder() {
    Provider.of<OrderProvider>(context, listen: false).placeOrder(
      '1',
      Provider.of<AuthProvider>(context, listen: false).getUserToken(),
    );
  }
}
