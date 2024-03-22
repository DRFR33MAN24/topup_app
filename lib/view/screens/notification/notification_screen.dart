import 'package:flutter/material.dart';
import 'package:giftme/helper/date.dart';

import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/provider/notification_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/app_constants.dart';
import 'package:giftme/util/color_resources.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';

import 'package:giftme/view/basewidgets/no_internet_screen.dart';
import 'package:giftme/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatelessWidget {
  final bool isBacButtonExist;
  const NotificationScreen({Key? key, this.isBacButtonExist = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false)
        .initNotificationList(context);

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Consumer<NotificationProvider>(
            builder: (context, notification, child) {
              return notification.notificationList != null
                  ? notification.notificationList!.isNotEmpty
                      ? RefreshIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                          onRefresh: () async {
                            await Provider.of<NotificationProvider>(context,
                                    listen: false)
                                .initNotificationList(context);
                          },
                          child: ListView.builder(
                            itemCount:
                                Provider.of<NotificationProvider>(context)
                                    .notificationList!
                                    .length,
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => NotificationDialog(
                                        notificationModel: notification
                                            .notificationList![index])),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: Dimensions.paddingSizeSmall),
                                  color: Theme.of(context).cardColor,
                                  child: ListTile(
                                    leading: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      image:
                                          '${AppConstants.baseUrl + "/storage/"}${notification.notificationList![index].image}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover),
                                    )),
                                    title: Text(
                                        notification
                                            .notificationList![index].title!,
                                        style: titilliumRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                        )),
                                    subtitle: Text(
                                      getDateFormatted(DateTime.parse(
                                              notification
                                                  .notificationList![index]
                                                  .createdAt!)
                                          .toIso8601String()),
                                      style: titilliumRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color:
                                              ColorResources.getHint(context)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const NoInternetOrDataScreen(isNoInternet: false)
                  : const NotificationShimmer();
            },
          ),
        ),
      ]),
    );
  }
}

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          color: ColorResources.getGrey(context),
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled:
                Provider.of<NotificationProvider>(context).notificationList ==
                    null,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.notifications)),
              title: Container(height: 20, color: ColorResources.white),
              subtitle:
                  Container(height: 10, width: 50, color: ColorResources.white),
            ),
          ),
        );
      },
    );
  }
}
