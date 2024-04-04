import 'package:flutter/material.dart';
import 'package:giftme/data/model/response/category_model.dart' as cat;
import 'package:giftme/provider/profile_provider.dart';
import 'package:giftme/util/app_constants.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
import 'package:giftme/view/screens/category/telecom_category_details_screen.dart';
import 'package:giftme/view/screens/telecom_card/telecom_card_details.dart';
import 'package:giftme/view/screens/transfer_balance/transfer_balance.dart';
import 'package:provider/provider.dart';

class ServiceWidget extends StatefulWidget {
  final cat.Service service;
  final bool? isSelected;
  final bool isTelecom;
  const ServiceWidget(
      {Key? key,
      required this.service,
      required this.isSelected,
      required this.isTelecom})
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
      onTap: () {
        if (widget.isTelecom) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  TelecomCardDetials(service: widget.service)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background,
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
                        AppConstants.services_url +
                        widget.service.image!,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder,
                        width: Dimensions.profileImageSize,
                        height: Dimensions.profileImageSize,
                        fit: BoxFit.cover),
                  ),
                ),
                // Positioned(
                //     top: 5,
                //     right: 5,
                //     child: Container(
                //       padding: EdgeInsets.all(5),
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: Colors.green),
                //       child: Text(
                //         "-5.00%",
                //         style: TextStyle(
                //             color: Theme.of(context).colorScheme.onPrimary),
                //       ),
                //     ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                        // softWrap: false,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        widget.service.title!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 13),
                      ),
                    ),
                    CustomPrice(
                        price: Provider.of<ProfileProvider>(context)
                                    .userInfoModel!
                                    .isReseller ==
                                1
                            ? widget.service.reseller_price!
                            : widget.service.price!)
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
