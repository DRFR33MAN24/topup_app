import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giftme/provider/printing_provider.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:giftme/main.dart';
import 'package:giftme/provider/payment_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/images.dart';

class PrinterSettings extends StatefulWidget {
  const PrinterSettings({Key? key}) : super(key: key);

  @override
  _PrinterSettingsState createState() => _PrinterSettingsState();
}

class _PrinterSettingsState extends State<PrinterSettings> {
  TextEditingController ip = TextEditingController();
  TextEditingController port = TextEditingController();
  TextEditingController size = TextEditingController();
  bool? isWifi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ip.text =
        Provider.of<PrintingProvider>(Get.context!, listen: false).printerIP!;
    port.text =
        Provider.of<PrintingProvider>(Get.context!, listen: false).printerPort!;
    size.text = Provider.of<PrintingProvider>(Get.context!, listen: false)
        .pageSize!
        .toString();

    isWifi = Provider.of<PrintingProvider>(Get.context!, listen: false).isWifi!;
  }

  @override
  Widget build(BuildContext context) {
    print(isWifi);
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text('Printer Settings',
                  style: robotoRegular.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
          ),
          body: Consumer<PrintingProvider>(
              builder: (context, printingProvider, child) {
            return SingleChildScrollView(
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Printer IP Address'),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: ip,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Printer Port'),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: port,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Printer Paper Size'),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: size,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Wifi/Bluetooth'),
                        Switch(
                            value: isWifi!,
                            onChanged: (value) {
                              setState(() {
                                isWifi = value;
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      buttonText: "Save Settings",
                      onTap: () {
                        printingProvider.updateSettings(
                            int.parse(size.text.trim()),
                            ip.text.trim(),
                            port.text.trim(),
                            isWifi);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            content: Text("Settings Saved"),
                            backgroundColor: Colors.green));
                      },
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
