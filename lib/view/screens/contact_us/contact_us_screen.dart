import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:giftme/main.dart';
import 'package:giftme/provider/payment_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/images.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              Text('Contact Us',
                  style: robotoRegular.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
          ),
          body: Consumer<SplashProvider>(
              builder: (context, splashProvider, child) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).highlightColor,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  child: Column(children: [
                    Text(
                      "يرجى ارسال اشعار التحويل عبر واتساب مع ملاحظة ان عملية اضافة الرصيد تستغرق 1-30 دقيقة",
                      style: robotoBold,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(Images.wish_gateway,
                          width: 250, height: 125),
                    ),
                    Text(
                      "الرقم المخصص للدفع عبر ويش",
                      style: robotoBold,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          splashProvider.configModel!.phone!,
                          style: robotoBold.copyWith(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                text: splashProvider.configModel!.phone!));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                content: Text("Phone copied!"),
                                backgroundColor: Colors.green));
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            color: Theme.of(context).canvasColor,
                            child: Icon(
                              Icons.copy,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "بعد الدفع يرجى إعلامنا بالطرق الموضحة ادناه",
                      style: robotoBold,
                    ),
                  ]),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).highlightColor,
                          spreadRadius: 2),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  child: Column(children: [
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                          "Support: ${splashProvider.configModel!.phone!}"),
                      onTap: () async {
                        Uri uri = Uri(
                            scheme: 'tel',
                            path: splashProvider.configModel!.phone);
                        await launchUrl(uri);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.chat,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                          "Whatsapp: ${splashProvider.configModel!.phone!}"),
                      onTap: () async {
                        Uri uri = Uri(
                            scheme: 'https',
                            path: 'wa.me/${splashProvider.configModel!.phone}');
                        await launchUrl(uri);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                      title:
                          Text("Email: ${splashProvider.configModel!.email!}"),
                      onTap: () async {
                        Uri uri = Uri(
                            scheme: 'mailto',
                            path: splashProvider.configModel!.email);
                        await launchUrl(uri);
                      },
                    ),
                  ]),
                )
              ],
            );
          }),
        ));
  }
}
