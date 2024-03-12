import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/data/model/response/style_model.dart';
import 'package:stylizeit/localization/language_constants.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'dart:io';

import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/basewidgets/style_image_widget.dart';
import 'package:stylizeit/view/screens/style/edit_photo_screen.dart';
import 'package:stylizeit/provider/style_provider.dart';

class StyleDetailsScreen extends StatefulWidget {
  final Style style;

  const StyleDetailsScreen({Key? key, required this.style}) : super(key: key);

  @override
  _StyleDetailsScreenState createState() => _StyleDetailsScreenState();
}

class _StyleDetailsScreenState extends State<StyleDetailsScreen> {
  late File _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                EditPhoto(image: _image, style: widget.style)));
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Wrap(
          children: [
            ListTile(
              title: Text("Photo Gallery"),
              onTap: () {
                // close the options modal
                Navigator.of(context).pop();
                // get image from gallery
                getImageFromGallery();
              },
            ),
            ListTile(
              title: Text("Camera"),
              onTap: () {
                // close the options modal
                Navigator.of(context).pop();
                // get image from camera
                getImageFromCamera();
              },
            )
          ],
        ),
      ),
    );
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
                Text(widget.style.name!,
                    style: robotoRegular.copyWith(
                        fontSize: 20, color: Theme.of(context).cardColor)),
              ]),
              backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                  ? Colors.black
                  : Theme.of(context).primaryColor,
            ),
            body: SafeArea(
                child:
                    Stack(children: [StyleImageWidget(style: widget.style)])),
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(8),
              child: CustomButton(
                buttonText: 'Apply',
                onTap: () {
                  showOptions();
                },
              ),
            )));
  }
}
