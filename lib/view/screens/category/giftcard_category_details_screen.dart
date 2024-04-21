import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/category_model.dart' as cat;
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/order_provider.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
import 'package:giftme/view/basewidgets/animated_custom_dialog.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:giftme/view/basewidgets/order_confirmation_dialog.dart';
import 'package:giftme/view/basewidgets/service_widget.dart';

import '../../../provider/profile_provider.dart';

class GiftCardCategoryDetailsScreen extends StatefulWidget {
  final cat.Category category;

  const GiftCardCategoryDetailsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _GiftCardCategoryDetailsScreenState createState() =>
      _GiftCardCategoryDetailsScreenState();
}

class _GiftCardCategoryDetailsScreenState
    extends State<GiftCardCategoryDetailsScreen> {
  late Map<cat.Service, bool> servicesMap;
  late cat.Service selectedService;
  late num? qty;

  TextEditingController qtyController = TextEditingController(text: "1");

  late List<String>? stringListReturnedFromApiCall;
  // This list of controllers can be used to set and get the text from/to the TextFields
  Map<String, TextEditingController> textEditingControllers = {};
  var textFields = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicesMap = Map.fromEntries(
        widget.category.services!.map((e) => MapEntry(e, false)));

    servicesMap.update(servicesMap.keys.first, (value) => true);
    selectedService = servicesMap.keys.first;
    if (selectedService.min_amount != null && selectedService.min_amount != 0) {
      qty = selectedService.min_amount;
      qtyController.text = qty.toString();
    } else {
      qty = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(selectedService.min_amount);
    buildDynamicFields();
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.category.title!),
              backgroundColor: Theme.of(context).colorScheme.background),
          body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleButtons(
                        isSelected: servicesMap.values.toList(),
                        renderBorder: false,
                        fillColor: Colors.transparent,
                        borderColor: Theme.of(context).primaryColor,
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < servicesMap.length;
                                buttonIndex++) {
                              cat.Service buttonIndexServ =
                                  servicesMap.keys.toList()[buttonIndex];
                              if (buttonIndex == index) {
                                servicesMap.update(
                                    buttonIndexServ, (value) => true);
                                selectedService = buttonIndexServ;
                              } else {
                                servicesMap.update(
                                    buttonIndexServ, (value) => false);
                              }
                            }
                          });
                        },
                        children: widget.category.services!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IgnorePointer(
                                      child: ServiceWidget(
                                    service: e,
                                    isSelected: servicesMap[e],
                                    isTelecom: false,
                                  )),
                                ))
                            .toList()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).highlightColor,
                          spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description:"),
                      SizedBox(
                        height: 10,
                      ),
                      selectedService.description != null
                          ? Html(data: selectedService.description!)
                          : SizedBox(),

                      selectedService.min_amount != null
                          ? (selectedService.min_amount != 0 &&
                                  selectedService.max_amount != 0)
                              ? (selectedService.max_amount != 1)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Quantity'),
                                            Text(
                                              '(min:${selectedService.min_amount} max:${selectedService.max_amount})',
                                              style: robotoBold.copyWith(
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
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
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r"[0-9.]")),
                                            CustomRangeTextInputFormatter(
                                                selectedService.min_amount!,
                                                selectedService.max_amount!),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox()
                              : SizedBox()
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      // Text("Player ID"),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // TextField(
                      //   controller: player_id,
                      // ),
                      ...textFields,
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          !Provider.of<OrderProvider>(context).isLoading
                              ? CustomButton(
                                  radius: 45,
                                  buttonText: "Buy",
                                  onTap: () {
                                    showAnimatedDialog(
                                        context,
                                        OrderConfirmationDialog(
                                            details:
                                                "Do you really want to submit this order",
                                            totalPrice: calcPrice(),
                                            onConfirm: placeOrder));
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        ));
  }

  void buildDynamicFields() {
    stringListReturnedFromApiCall = selectedService.params;
    textFields = <Widget>[];
    textEditingControllers = {};
    stringListReturnedFromApiCall!.forEach((str) {
      if (str.isNotEmpty) {
        var textEditingController = new TextEditingController();
        textEditingControllers.putIfAbsent(str, () => textEditingController);
        textFields.add(Text(str));
        textFields.add(SizedBox(
          height: 10,
        ));
        textFields.add(TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: textEditingController,
        ));
        textFields.add(SizedBox(
          height: 10,
        ));
      }
    });
  }

  placeOrder() async {
    if (!validateOrder()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Text("Please Enter all fields to continue"),
          backgroundColor: Colors.red));
      return;
    }
    Map<String, String> fields = {};
    selectedService.params!.forEach((str) {
      if (str.isNotEmpty) {
        fields.addEntries({str: textEditingControllers[str]!.text}.entries);
      }
    });
    fields.addEntries({'quantity': qty.toString()}.entries);
    await Provider.of<OrderProvider>(context, listen: false).placeOrder(
        selectedService.id.toString(),
        selectedService.categoryId.toString(),
        fields,
        Provider.of<SplashProvider>(context, listen: false).currentCurrency,
        Provider.of<AuthProvider>(context, listen: false).getUserToken(),
        route);
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
  }

  bool validateOrder() {
    bool isValid = true;
    selectedService.params!.forEach((str) {
      if (str.isNotEmpty) {
        String fieldStr = textEditingControllers[str]!.text;
        if (fieldStr.isEmpty) {
          isValid = false;
        }
      }
    });
    return isValid;
  }

  String calcPrice() {
    if (Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel!
            .isReseller ==
        1) {
      return (qty! * num.parse(selectedService.reseller_price!))
          .toStringAsFixed(2);
    } else {
      return (qty! * num.parse(selectedService.price!)).toStringAsFixed(3);
    }
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
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  late final int min;
  late final int max;

  CustomRangeTextInputFormatter(int this.min, int this.max);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < min)
      return TextEditingValue().copyWith(text: min.toString());

    return int.parse(newValue.text) > max
        ? TextEditingValue().copyWith(text: max.toString())
        : newValue;
  }
}
