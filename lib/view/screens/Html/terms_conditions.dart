import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../provider/splash_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../util/custom_themes.dart';
import '../../../util/dimensions.dart';

class TermsAndConditonsScreen extends StatefulWidget {
  const TermsAndConditonsScreen({Key? key}) : super(key: key);

  @override
  _TermsAndConditonsScreenState createState() =>
      _TermsAndConditonsScreenState();
}

class _TermsAndConditonsScreenState extends State<TermsAndConditonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text("Terms and Conditions",
                  style: robotoRegular.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
            backgroundColor: Theme.of(context).colorScheme.background),
        body: Html(
            data: Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .termsConditions!));
  }
}
