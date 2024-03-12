import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stylizeit/data/model/response/order_model.dart';
import 'package:stylizeit/data/model/response/style_model.dart';
import 'package:stylizeit/provider/auth_provider.dart';
import 'package:stylizeit/provider/order_provider.dart';

import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_editor/image_editor.dart'
    show
        ClipOption,
        FlipOption,
        ImageEditor,
        ImageEditorOption,
        Option,
        OutputFormat,
        ScaleOption,
        RotateOption;
import 'package:image_size_getter/image_size_getter.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/screens/style/widget/scale_widget.dart';

import 'widget/clip_widget.dart';

class EditPhoto extends StatefulWidget {
  final File image;
  final Style style;
  const EditPhoto({Key? key, required this.image, required this.style})
      : super(key: key);

  @override
  _EditPhotoState createState() => _EditPhotoState();
}

class _EditPhotoState extends State<EditPhoto> {
  late Map<String, bool> isSelected;
  ImageProvider? provider;
  Uint8List? result;

  PhotoViewController? controller;
  PhotoViewControllerValue? _value;

  num image_width = 715;

  num image_height = 715;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = PhotoViewController()..outputStateStream.listen(listener);

    provider = Image.file(widget.image).image;
    result = widget.image.readAsBytesSync();

    isSelected = {
      "1:1": true,
      "3:4": false,
      "4:3": false,
      "16:9": false,
      "9:16": false
    };
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    //print('dbg ${value}');
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          if (!orderProvider.connected) {
            return true;
          } else {
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Simple usage',
                style: robotoRegular.copyWith(
                    fontSize: 20, color: Theme.of(context).cardColor)),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(Icons.settings_backup_restore),
            //     onPressed: restore,
            //     tooltip: 'Restore image to default.',
            //   ),
            // ],
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: PhotoView(
                        controller: controller,
                        imageProvider: Image.file(widget.image).image,
                      ),
                    ),
                  ),
                  // ToggleButtons(
                  //     isSelected: isSelected.values.toList(),
                  //     onPressed: (int index) {
                  //       setState(() {
                  //         for (int buttonIndex = 0;
                  //             buttonIndex < isSelected.length;
                  //             buttonIndex++) {
                  //           String buttonIndexStr =
                  //               isSelected.keys.toList()[buttonIndex];
                  //           if (buttonIndex == index) {
                  //             isSelected.update(buttonIndexStr, (value) => true);
                  //           } else {
                  //             isSelected.update(buttonIndexStr, (value) => false);
                  //           }
                  //         }
                  //       });
                  //     },
                  //     children: isSelected.keys.map((e) => Text(e)).toList()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      buttonText: "Apply",
                      onTap: () {
                        if (!orderProvider.connected) {
                          applyStyleToImage();
                        }
                      },
                    ),
                  ),
                ],
              ),
              orderProvider.connected
                  ? Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(orderProvider.progress),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      );
    });
  }

  void applyStyleToImage() {
    num scaleX = image_width / (_value!.scale! * 2);
    num scaleY = image_height / (_value!.scale! * 2);
    num offsetX = (-_value!.position.dx + scaleX / 2);
    num offsetY = (-_value!.position.dy + scaleY / 2);
    //print("dbg ${offsetX},${offsetY},${scaleX},${scaleY}");

    _clip(ClipOption(x: offsetX, y: offsetY, width: scaleX, height: scaleY));

    Provider.of<OrderProvider>(context, listen: false).placeOrder(
        widget.style.id.toString(),
        result,
        Provider.of<AuthProvider>(context, listen: false).getUserToken());
  }

  void setProvider(ImageProvider? provider, Uint8List? result) {
    this.provider = provider;
    this.result = result;
    setState(() {});
  }

  void restore() {
    setProvider(Image.file(widget.image).image, widget.image.readAsBytesSync());
  }

  Future<Uint8List> getAssetImage() async {
    Uint8List image = widget.image.readAsBytesSync();
    var decodedImage = await decodeImageFromList(image);
    image_width = decodedImage.width;
    image_height = decodedImage.height;
    // print("dbg ${image_width},${image_height}");

    return image;
  }

  Future<void> _clip(ClipOption clipOpt) async {
    handleOption(<Option>[clipOpt]);
  }

  applyStyle() async {
    Provider.of<OrderProvider>(context, listen: false)
        .placeOrder("1", result, "");
  }

  Future<void> handleOption(List<Option> options) async {
    final ImageEditorOption option = ImageEditorOption();
    for (int i = 0; i < options.length; i++) {
      final Option o = options[i];
      option.addOption(o);
    }

    option.outputFormat = const OutputFormat.png();

    final Uint8List assetImage = await getAssetImage();

    //final srcSize = ImageSizeGetter.getSize(MemoryInput(assetImage));

    //print(const JsonEncoder.withIndent('  ').convert(option.toJson()));
    final Uint8List? result = await ImageEditor.editImage(
      image: assetImage,
      imageEditorOption: option,
    );

    if (result == null) {
      setProvider(null, null);
      return;
    }

    //final resultSize = ImageSizeGetter.getSize(MemoryInput(result));

    //print('srcSize: $srcSize, resultSize: $resultSize');

    final MemoryImage img = MemoryImage(result);
    // await ImageGallerySaver.saveImage(result);
    setProvider(img, result);
  }
}
