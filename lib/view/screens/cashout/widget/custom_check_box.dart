import 'package:flutter/material.dart';
import 'package:stylizeit/localization/language_constants.dart';
import 'package:stylizeit/provider/order_provider.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final int index;
  final String? name;
  final bool isDigital;
  final String? icon;
  const CustomCheckBox(
      {Key? key,
      required this.index,
      required this.name,
      this.isDigital = false,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PyamentProvider>(
      builder: (context, payment, child) {
        return InkWell(
          onTap: () => payment.setPaymentMethod(index),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: payment.paymentMethodIndex == index
                      ? Theme.of(context).primaryColor.withOpacity(.5)
                      : Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  boxShadow: [
                    BoxShadow(
                        color: payment.paymentMethodIndex == index
                            ? Theme.of(context).hintColor.withOpacity(.2)
                            : Theme.of(context).hintColor.withOpacity(.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1))
                  ]),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                    width: 80,
                    child: Image.asset(
                      icon!,
                    )),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        )),
                  ],
                ),
                // Checkbox(
                //   shape: const CircleBorder(),
                //   value: order.paymentMethodIndex == index,
                //   activeColor: Theme.of(context).primaryColor,
                //   onChanged: (bool? isChecked) =>
                //       order.setPaymentMethod(index),
                // ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
