import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:giftme/localization/language_constants.dart';
import 'package:giftme/main.dart';
import 'package:giftme/util/color_resources.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';

class NoInternetOrDataScreen extends StatelessWidget {
  final bool isNoInternet;
  final Widget? child;
  const NoInternetOrDataScreen(
      {Key? key, required this.isNoInternet, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isNoInternet ? Images.noInternet : Images.noData,
                width: 150, height: 150),
            Text(
                isNoInternet
                    ? getTranslated('OPPS', context)!
                    : getTranslated('sorry', context)!,
                style: titilliumBold.copyWith(
                  fontSize: 30,
                  color: isNoInternet
                      ? Theme.of(context).textTheme.bodyLarge!.color
                      : ColorResources.getColombiaBlue(context),
                )),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(
              isNoInternet
                  ? getTranslated('no_internet_connection', context)!
                  : getTranslated('no_data_found', context)!,
              textAlign: TextAlign.center,
              style: titilliumRegular,
            ),
            const SizedBox(height: 40),
            isNoInternet
                ? Container(
                    height: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorResources.getYellow(context)),
                    child: TextButton(
                      onPressed: () async {
                        if (await Connectivity().checkConnectivity() !=
                            ConnectivityResult.none) {
                          Navigator.pushReplacement(Get.context!,
                              MaterialPageRoute(builder: (_) => child!));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(getTranslated('RETRY', context)!,
                            style: titilliumSemiBold.copyWith(
                                color: Theme.of(context).canvasColor,
                                fontSize: Dimensions.fontSizeLarge)),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
