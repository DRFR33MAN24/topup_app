import 'package:flutter/material.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/util/color_resources.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';

class OrderConfirmationDialog extends StatelessWidget {
  final String details;
  final String? totalPrice;
  final Function onConfirm;
  const OrderConfirmationDialog(
      {Key? key,
      required this.details,
      required this.onConfirm,
      this.totalPrice})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge, vertical: 50),
          child:
              Text(details, style: robotoRegular, textAlign: TextAlign.center),
        ),
        const Divider(height: 0, color: ColorResources.hintTextColor),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Price:"),
              CustomPrice(price: totalPrice!),
            ],
          ),
        ),
        const Divider(height: 0, color: ColorResources.hintTextColor),
        Row(children: [
          Expanded(
              child: InkWell(
            onTap: () {
              onConfirm();

              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('YES', context)!,
                  style: titilliumBold.copyWith(
                      color: Theme.of(context).primaryColor)),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: ColorResources.red,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('NO', context)!,
                  style: titilliumBold.copyWith(color: ColorResources.white)),
            ),
          )),
        ]),
      ]),
    );
  }
}
