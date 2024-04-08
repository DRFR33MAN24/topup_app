import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/custom_themes.dart';

class CustomPrice extends StatefulWidget {
  final String price;
  final String? formatStyle;
  const CustomPrice({Key? key, required this.price, this.formatStyle})
      : super(key: key);

  @override
  _CustomPriceState createState() => _CustomPriceState();
}

class _CustomPriceState extends State<CustomPrice> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
      if (splashProvider.currentCurrency == "USD") {
        return Text(
          "${getPricePrefix(widget.formatStyle)}${widget.price} \$",
          style: robotoBold.copyWith(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: getPriceColor(widget.formatStyle)),
        );
      } else {
        return Text(
            "${getPricePrefix(widget.formatStyle)}${double.parse(widget.price) * splashProvider.configModel!.currencyConversionFactor!} LBP",
            style: robotoBold.copyWith(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: getPriceColor(widget.formatStyle)));
      }
    });
  }

  getPriceColor(String? s) {
    switch (s) {
      case null:
        return Theme.of(context).colorScheme.onSurface;
        break;
      case "+":
        return Colors.green;
        break;
      case "-":
        return Colors.red;
        break;

      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  getPricePrefix(String? s) {
    switch (s) {
      case null:
        return "";
        break;
      case "charge":
        return "+";
        break;
      case "decharge":
        return "-";
        break;

      default:
        return "";
    }
  }
}
