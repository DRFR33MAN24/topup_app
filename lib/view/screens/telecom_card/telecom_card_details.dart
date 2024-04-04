import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:giftme/data/model/response/category_model.dart';
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

import '../../../provider/profile_provider.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';
import '../../basewidgets/CustomPrice.dart';
import '../category/giftcard_category_details_screen.dart';

class TelecomCardDetials extends StatefulWidget {
  final Service service;
  const TelecomCardDetials({Key? key, required this.service}) : super(key: key);

  @override
  _TelecomCardDetialsState createState() => _TelecomCardDetialsState();
}

class _TelecomCardDetialsState extends State<TelecomCardDetials> {
  late num? qty = 1;

  TextEditingController qtyController = TextEditingController(text: "1");

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
                Text(widget.service.title!,
                    style: robotoRegular.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground)),
              ]),
              backgroundColor: Theme.of(context).colorScheme.background),
          body: SingleChildScrollView(
            child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
              return Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BalanceWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ClipRRect(
                        // key: key,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          image: AppConstants.baseUrl +
                              AppConstants.services_url +
                              widget.service.image!,
                          imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder,
                              width: Dimensions.profileImageSize,
                              height: Dimensions.profileImageSize,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Quantity"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: qtyController,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            qty = num.parse(value);
                          }
                        });
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        CustomRangeTextInputFormatter(
                            widget.service.min_amount!,
                            widget.service.max_amount!),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total price"),
                        CustomPrice(price: calcPrice()),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    !orderProvider.isLoading
                        ? CustomButton(
                            buttonText: "Buy",
                            onTap: () {
                              showAnimatedDialog(
                                  context,
                                  OrderConfirmationDialog(
                                      totalPrice: calcPrice(),
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
          ),
        ));
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

  String calcPrice() {
    if (Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel!
            .isReseller ==
        1) {
      return (qty! * num.parse(widget.service.reseller_price!))
          .toStringAsFixed(2);
    } else {
      return (qty! * num.parse(widget.service.price!)).toStringAsFixed(2);
    }
  }

  placeOrder() async {
    await Provider.of<OrderProvider>(context, listen: false).placeTelecomrOrder(
        widget.service.id.toString(),
        widget.service.categoryId.toString(),
        qty.toString(),
        Provider.of<AuthProvider>(context, listen: false).getUserToken(),
        route);

    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
  }
}
