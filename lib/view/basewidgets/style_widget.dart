import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/style_model.dart';
import 'package:stylizeit/util/color_resources.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';
import 'package:stylizeit/view/screens/style/style_details_screen.dart';

class StyleWidget extends StatefulWidget {
  final Style style;
  const StyleWidget({Key? key, required this.style}) : super(key: key);

  @override
  State<StyleWidget> createState() => _StyleWidgetState();
}

class _StyleWidgetState extends State<StyleWidget>
    with SingleTickerProviderStateMixin {
  // var key = GlobalKey();
  // Size? redboxSize;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   setState(() {
    //     redboxSize = getRedBoxSize(key.currentContext!);
    //     print(redboxSize);

    //     animation =
    //         Tween(begin: 0.0, end: redboxSize!.width).animate(controller)
    //           ..addListener(() {
    //             setState(() {});
    //           });
    //   });
    // });
    animation = Tween(begin: 0.1, end: 0.9).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                StyleDetailsScreen(style: widget.style)));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  // key: key,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    widget.style.img_after!,
                  ),
                ),
                ClipRRect(
                  // borderRadius: const BorderRadius.all(Radius.circular(10)),
                  clipper: WidthClipper(animation.value),
                  child: Image.network(
                    widget.style.img_before!,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0) //
                            ),
                        color: Theme.of(context).primaryColor),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('50',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Image.asset(
                          Images.coins,
                          height: Dimensions.iconSizeSmall,
                          width: Dimensions.iconSizeSmall,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.style.name!,
                style: const TextStyle(
                    color: Color.fromARGB(255, 2, 2, 2), fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WidthClipper extends CustomClipper<RRect> {
  late double value;

  @override
  RRect getClip(Size size) {
    RRect rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width * value, size.height),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(0));
    return rect;
  }

  @override
  bool shouldReclip(WidthClipper oldClipper) {
    return true;
  }

  WidthClipper(double value) {
    this.value = value;
  }
}
