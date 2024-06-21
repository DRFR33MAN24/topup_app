import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
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
import 'package:giftme/data/model/response/category_model.dart' as cat;

import '../../../provider/profile_provider.dart';

class TelecomCreditCategoryDetailsScreen extends StatefulWidget {
  final cat.Category category;
  const TelecomCreditCategoryDetailsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _TelecomCreditCategoryDetailsScreenState createState() =>
      _TelecomCreditCategoryDetailsScreenState();
}

class _TelecomCreditCategoryDetailsScreenState
    extends State<TelecomCreditCategoryDetailsScreen> {
  TextEditingController _amountController = TextEditingController(text: "0");
  String amount = "0.00";

  // TextEditingController note = TextEditingController();
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
                Text(widget.category.title!,
                    style: robotoRegular.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface)),
              ]),
              backgroundColor: Theme.of(context).colorScheme.background),
          body:
              Consumer<OrderProvider>(builder: (context, orderProvider, child) {
            return Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  BalanceWidget(),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).highlightColor,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Column(children: [
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
                      TextField(
                        controller: _amountController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Amount (USD)",
                          hintStyle: titilliumRegular.copyWith(
                              color: Theme.of(context).hintColor),
                          errorStyle: const TextStyle(height: 1.5),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 15),
                          isDense: true,
                        ),
                        onChanged: (value) {
                          setState(() {
                            amount = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total price"),
                          Text(
                            calcPrice() + " LBP",
                            style: robotoBold.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      !orderProvider.isLoading
                          ? CustomButton(
                              buttonText: "Send",
                              onTap: () {
                                String phone = _numberController!.text.trim();
                                String amount = _amountController.text.trim();

                                if (phone.isEmpty || amount.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          content: Text(
                                              'Please enter both fields to continue'),
                                          backgroundColor: Colors.red));
                                } else {
                                  showAnimatedDialog(
                                      context,
                                      OrderConfirmationDialog(
                                          totalPrice: calcPrice(),
                                          lebanese: true,
                                          details: "Confirm order?",
                                          onConfirm: placeOrder));
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)))
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).highlightColor,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.category.services!.first.description!,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ));
  }

  placeOrder() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .placeTelecomCreditTransferOrder(
            _numberController!.text.trim(),
            calcPrice(),
            Provider.of<AuthProvider>(context, listen: false).getUserToken(),
            route);

    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
  }

  route(String message, bool error) async {
    if (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text(message),
          backgroundColor: Colors.red));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text(message),
          backgroundColor: Colors.green));
    }
  }

  calcPrice() {
    if (_amountController.text != "") {
      return "${(double.parse(amount.trim()) + (double.parse(amount.trim()) * double.parse(Provider.of<SplashProvider>(context, listen: false).configModel!.credit_transfer_percent!) / 100) * Provider.of<SplashProvider>(context, listen: false).configModel!.currencyConversionFactor!).toStringAsFixed(3)}";
    } else {
      return "0.00";
    }
  }
}
