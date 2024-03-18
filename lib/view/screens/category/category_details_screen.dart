import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/data/model/response/category_model.dart' as cat;
import 'package:stylizeit/data/model/response/order_model.dart';
import 'package:stylizeit/localization/language_constants.dart';
import 'package:stylizeit/provider/order_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/view/basewidgets/CustomPrice.dart';
import 'dart:io';

import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/basewidgets/service_widget.dart';
import 'package:stylizeit/view/basewidgets/style_image_widget.dart';

import 'package:stylizeit/provider/style_provider.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final cat.Category category;

  const CategoryDetailsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  late Map<cat.Service, bool> servicesMap;
  late cat.Service selectedService;

  TextEditingController qty = TextEditingController();
  TextEditingController player_id = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicesMap = Map.fromEntries(
        widget.category.services!.map((e) => MapEntry(e, false)));

    servicesMap.update(servicesMap.keys.first, (value) => true);
    selectedService = servicesMap.keys.first;
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
              title: Text(widget.category.title!),
              backgroundColor: Theme.of(context).primaryColor),
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
                                          isSelected: servicesMap[e])),
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).highlightColor,
                          spreadRadius: 2),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity"),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: qty,
                        inputFormatters: [
                          CustomRangeTextInputFormatter(
                              selectedService.min_amount!,
                              selectedService.max_amount!),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("ID"),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: player_id,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("total price"),
                              CustomPrice(price: selectedService.price!),
                            ],
                          ),
                          !Provider.of<OrderProvider>(context).isLoading
                              ? CustomButton(
                                  radius: 45,
                                  buttonText: "Buy",
                                  onTap: () {},
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

  placeOrder() async {
    // Provider.of<OrderProvider>(context, listen: false)
    //     .placeOrder(selectedService.id, qty.text);
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
