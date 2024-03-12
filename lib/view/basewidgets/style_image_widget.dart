import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/style_model.dart';

import 'package:stylizeit/localization/language_constants.dart';
import 'package:stylizeit/provider/order_provider.dart';

import 'package:stylizeit/provider/theme_provider.dart';

import 'package:stylizeit/util/color_resources.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';

import 'package:provider/provider.dart';

import 'package:image_compare_slider/image_compare_slider.dart';

class StyleImageWidget extends StatelessWidget {
  final Style style;
  StyleImageWidget({Key? key, required this.style}) : super(key: key);

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, locationProvider, child) {
        return Container(
          child: Center(
            child: ImageCompareSlider(
              itemOne: Image.network(
                style.img_after!,
                fit: BoxFit.fitHeight,
              ),
              itemTwo: Image.network(
                style.img_before!,
                fit: BoxFit.fitHeight,
              ),
              itemOneBuilder: (child, context) => Container(
                height: 400,
                child: ClipRRect(
                  child: child,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              itemTwoBuilder: (child, context) => Container(
                height: 400,
                child: ClipRRect(
                  child: child,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
