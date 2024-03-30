import 'package:flutter/material.dart';
import 'package:giftme/data/model/response/category_model.dart' as cat;
import 'package:giftme/util/app_constants.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/screens/category/giftcard_category_details_screen.dart';
import 'package:giftme/view/screens/category/telecom_category_details_screen.dart';
import 'package:giftme/view/screens/credit_transfer/credit_transfer.dart';

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
        if (widget.category.type == "giftcard") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  GiftCardCategoryDetailsScreen(category: widget.category)));
        } else if (widget.category.type == "telecom") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  TelecomCategoryDetailsScreen(category: widget.category)));
        } else if (widget.category.type == "utility") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  GiftCardCategoryDetailsScreen(category: widget.category)));
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext context) =>
          //         CreditTransfer(category: widget.category)));
        }
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
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    width: Dimensions.profileImageSize,
                    height: Dimensions.profileImageSize,
                    fit: BoxFit.cover,
                    image: AppConstants.baseUrl +
                        AppConstants.categories_url +
                        widget.category.image!,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder,
                        width: Dimensions.profileImageSize,
                        height: Dimensions.profileImageSize,
                        fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.category.title!,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
