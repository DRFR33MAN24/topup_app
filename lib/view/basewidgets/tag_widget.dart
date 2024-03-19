import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/category_model.dart' as cat;
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';

class TagWidget extends StatefulWidget {
  final cat.Tag tag;
  final bool? isSelected;
  const TagWidget({Key? key, required this.tag, required this.isSelected})
      : super(key: key);

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget>
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
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: widget.isSelected!
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).highlightColor,
                spreadRadius: 2),
          ],
        ),
        margin: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  // key: key,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: widget.tag.image == null
                      ? Image.asset(
                          Images.placeholder_1x1,
                          fit: BoxFit.contain,
                          width: 100,
                        )
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3), BlendMode.darken),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            width: Dimensions.profileImageSize,
                            height: Dimensions.profileImageSize,
                            fit: BoxFit.cover,
                            image: AppConstants.baseUrl +
                                "/storage/" +
                                widget.tag.image!,
                            imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder,
                                width: Dimensions.profileImageSize,
                                height: Dimensions.profileImageSize,
                                fit: BoxFit.cover),
                          ),
                        ),
                ),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.tag.tag!,
                            maxLines: 1,
                            softWrap: false,
                            style: robotoBold.copyWith(color: Colors.white),
                          ),
                        ))),
                // Positioned.fill(
                //     child: Container(
                //   color: Colors.red,
                // ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
