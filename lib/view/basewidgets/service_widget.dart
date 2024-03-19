import 'package:flutter/material.dart';
import 'package:stylizeit/data/model/response/category_model.dart' as cat;
import 'package:stylizeit/util/app_constants.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';
import 'package:stylizeit/view/basewidgets/CustomPrice.dart';

class ServiceWidget extends StatefulWidget {
  final cat.Service service;
  final bool? isSelected;
  const ServiceWidget(
      {Key? key, required this.service, required this.isSelected})
      : super(key: key);

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget>
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
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    image: AppConstants.baseUrl +
                        "/storage/" +
                        widget.service.image!,
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
              child: SizedBox(
                width: 100,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      widget.service.title!,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    CustomPrice(price: widget.service.price!)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
