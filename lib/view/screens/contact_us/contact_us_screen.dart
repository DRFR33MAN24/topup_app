import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftme/main.dart';
import 'package:giftme/provider/payment_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

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
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text("Support: ${splashProvider.configModel!.phone!}"),
                  onTap: () async {
                    Uri uri = Uri(
                        scheme: 'tel', path: splashProvider.configModel!.phone);
                    await launchUrl(uri);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Theme.of(context).primaryColor,
                  ),
                  title:
                      Text("Whatsapp: ${splashProvider.configModel!.phone!}"),
                  onTap: () async {
                    Uri uri = Uri(
                        scheme: 'https',
                        path: 'wa.me/${splashProvider.configModel!.phone}');
                    await launchUrl(uri);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text("Email: ${splashProvider.configModel!.email!}"),
                  onTap: () async {
                    Uri uri = Uri(
                        scheme: 'mailto',
                        path: splashProvider.configModel!.email);
                    await launchUrl(uri);
                  },
                ),
              ],
            );
          }),
        ));
  }
}
