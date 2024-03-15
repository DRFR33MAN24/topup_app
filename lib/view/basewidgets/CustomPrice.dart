import 'package:flutter/material.dart';

class CustomPrice extends StatefulWidget {
  final String price;
  const CustomPrice({Key? key, required this.price}) : super(key: key);

  @override
  _CustomPriceState createState() => _CustomPriceState();
}

class _CustomPriceState extends State<CustomPrice> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.price);
  }
}
