import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/provider/splash_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';

class CustomPrice extends StatefulWidget {
  final String price;
  const CustomPrice({Key? key, required this.price}) : super(key: key);

  @override
  _CustomPriceState createState() => _CustomPriceState();
}

class _CustomPriceState extends State<CustomPrice> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
      if (splashProvider.currentCurrency == "USD") {
        return Text(
          "${widget.price} \$",
          style: robotoBold.copyWith(fontSize: 18, fontStyle: FontStyle.italic),
        );
      } else {
        return Text(
            "${double.parse(widget.price) * splashProvider.configModel!.currencyConversionFactor!} LBP");
      }
    });
  }
}
