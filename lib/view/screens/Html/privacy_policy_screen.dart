import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../provider/splash_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../util/custom_themes.dart';
import '../../../util/dimensions.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text("Privacy Policy",
                  style: robotoRegular.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
            backgroundColor: Theme.of(context).colorScheme.background),
        body: SingleChildScrollView(
          child: Html(
              data: Provider.of<SplashProvider>(context, listen: false)
                  .configModel!
                  .privacyPolicy!),
        ));
  }
}
