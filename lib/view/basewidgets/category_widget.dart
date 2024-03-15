import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/category_model.dart' as cat;
import 'package:stylizeit/util/color_resources.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';
import 'package:stylizeit/view/screens/category/category_details_screen.dart';
import 'package:stylizeit/view/screens/style/style_details_screen.dart';

class CategoryWidget extends StatefulWidget {
  final cat.Category category;
  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget>
    with SingleTickerProviderStateMixin {
  // var key = GlobalKey();
  // Size? redboxSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                CategoryDetailsScreen(category: widget.category)));
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
                    widget.category.image!,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.category.title!,
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
