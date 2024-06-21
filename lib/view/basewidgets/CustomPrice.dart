import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/custom_themes.dart';

class CustomPrice extends StatefulWidget {
  final String price;
  final String? formatStyle;
  final bool lebanese;

  const CustomPrice({
    Key? key,
    required this.price,
    this.formatStyle,
    this.lebanese = false,
  }) : super(key: key);

  @override
  _CustomPriceState createState() => _CustomPriceState();
}

class _CustomPriceState extends State<CustomPrice> {
  var formatterlbp = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );
  var formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  var formatterlbp2 = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );
  var formatter2 = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 5,
  );
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
      double price = double.parse(widget.price);
      if (!widget.lebanese) {
        if (splashProvider.currentCurrency == 'USD') {
          return Text(
            price < 0.01
                ? "${getPricePrefix(widget.formatStyle)}${formatter2.format(double.parse(widget.price))} \$"
                : "${getPricePrefix(widget.formatStyle)}${formatter.format(double.parse(widget.price))} \$",
            style: robotoBold.copyWith(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: getPriceColor(widget.formatStyle)),
          );
        } else {
          return Text(
            price < 0.01
                ? "${getPricePrefix(widget.formatStyle)}${formatterlbp2.format(double.parse(widget.price) * splashProvider.configModel!.currencyConversionFactor!)} LBP"
                : "${getPricePrefix(widget.formatStyle)}${formatterlbp.format(double.parse(widget.price) * splashProvider.configModel!.currencyConversionFactor!)} LBP",
            style: robotoBold.copyWith(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: getPriceColor(widget.formatStyle)),
          );
        }
      } else {
        return Text(
            // "${getPricePrefix(widget.formatStyle)}${double.parse(widget.price) * splashProvider.configModel!.currencyConversionFactor!} LBP",
            "${getPricePrefix(widget.formatStyle)}${formatterlbp.format(double.parse(widget.price))} LBP",
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
