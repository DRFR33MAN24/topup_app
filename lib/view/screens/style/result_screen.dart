import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/basewidgets/show_custom_snakbar.dart';

class ResultScreen extends StatefulWidget {
  final String img_after;
  final Uint8List img_before;
  const ResultScreen(
      {Key? key, required this.img_after, required this.img_before})
      : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String network_img;

  @override
  void initState() {
    super.initState();
    network_img = AppConstants.baseUrl + '/storage/' + widget!.img_after;
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
              title: Row(children: [
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('Result',
                    style: robotoRegular.copyWith(
                        fontSize: 20, color: Theme.of(context).cardColor)),
              ]),
              backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                  ? Colors.black
                  : Theme.of(context).primaryColor,
            ),
            body: Container(
              child: SafeArea(
                  child: Stack(children: [
                ImageCompareSlider(
                  itemOne: Image.network(
                    network_img,
                    fit: BoxFit.fitHeight,
                  ),
                  itemTwo: Image.memory(widget.img_before),
                  itemOneBuilder: (child, context) => Container(
                    child: child,
                    height: MediaQuery.of(context).size.height,
                  ),
                  itemTwoBuilder: (child, context) => Container(
                    child: child,
                    height: MediaQuery.of(context).size.height,
                  ),
                )
              ])),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(8),
              child: CustomButton(
                buttonText: 'Save',
                onTap: () {
                  _saveNetworkImage();
                },
              ),
            )));
  }

  _saveNetworkImage() async {
    var response = await Dio()
        .get(network_img, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: widget.img_after);

    if (result['isSuccess']) {
      showCustomSnackBar(
        'saved image',
        Get.context!,
        isError: false,
      );
    } else {
      showCustomSnackBar('failed to save image', Get.context!, isError: true);
    }
  }
}
