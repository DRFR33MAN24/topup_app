import 'package:flutter/material.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? buttonText;
  final bool isBuy;
  final bool isBorder;
  final Color? backgroundColor;
  final double? radius;
  const CustomButton(
      {Key? key,
      this.onTap,
      required this.buttonText,
      this.isBuy = false,
      this.isBorder = false,
      this.backgroundColor,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap as void Function()?,
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        height: 45,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // color: backgroundColor ??
            //     (isBuy
            //         ? const Color(0xffFE961C)
            //         : Theme.of(context).primaryColor),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor,
                  // spreadRadius: 1,
                  // blurRadius: 7,
                  offset: const Offset(0, 1)), // changes position of shadow
            ],
            borderRadius: BorderRadius.circular(radius != null
                ? radius!
                : isBorder
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(buttonText!,
              style: titilliumSemiBold.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                //  color: Theme.of(context).cardColor
              )),
        ),
      ),
    );
  }
}
