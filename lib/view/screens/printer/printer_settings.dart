import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giftme/provider/printing_provider.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
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

List<String> printOptions = ['58mm', '80mm'];

class _PrinterSettingsState extends State<PrinterSettings> {
  TextEditingController ip = TextEditingController();
  TextEditingController port = TextEditingController();
  String currentSize = printOptions[0];
  bool? isWifi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ip.text =
        Provider.of<PrintingProvider>(Get.context!, listen: false).printerIP!;
    port.text = Provider.of<PrintingProvider>(Get.context!, listen: false)
        .printerPort!
        .toString();
    currentSize =
        Provider.of<PrintingProvider>(Get.context!, listen: false).pageSize!;

    isWifi = Provider.of<PrintingProvider>(Get.context!, listen: false).isWifi!;
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
              Text('Printer Settings',
                  style: robotoRegular.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
          ),
          body: Consumer<PrintingProvider>(
              builder: (context, printingProvider, child) {
            return SingleChildScrollView(
              child: Column(
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
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Printer Paper Size'),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text('58mm'),
                          leading: Radio(
                            value: printOptions[0],
                            groupValue: currentSize,
                            onChanged: (value) {
                              setState(() {
                                currentSize = value.toString();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text('80mm'),
                          leading: Radio(
                            value: printOptions[1],
                            groupValue: currentSize,
                            onChanged: (value) {
                              setState(() {
                                currentSize = value.toString();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Bluetooth/Wifi'),
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
                            print(isWifi);
                            printingProvider.updateSettings(
                                currentSize,
                                ip.text.trim(),
                                int.parse(port.text.trim()),
                                isWifi);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                content: Text("Settings Saved"),
                                backgroundColor: Colors.green));
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        !printingProvider.isWifiPrinterReady &&
                                !printingProvider.isConnected
                            ? isWifi!
                                ? CustomButton(
                                    buttonText: "Connect to wifi printer",
                                    onTap: () {
                                      printingProvider.updateSettings(
                                          currentSize,
                                          ip.text.trim(),
                                          int.parse(port.text.trim()),
                                          isWifi);
                                      printingProvider.connect(-1);
                                    },
                                  )
                                : CustomButton(
                                    buttonText: "Scan Bluetooth",
                                    onTap: () async {
                                      printingProvider.updateSettings(
                                          currentSize,
                                          ip.text.trim(),
                                          int.parse(port.text.trim()),
                                          isWifi);

                                      printingProvider.scanBlutooth();
                                    },
                                  )
                            : CustomButton(
                                buttonText: "Disconnect",
                                onTap: () {
                                  printingProvider.disconnect();
                                },
                              ),
                      ],
                    ),
                  ),
                  printingProvider.printers.isNotEmpty &&
                          !printingProvider.isConnected
                      ? Container(
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
                          child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: printingProvider.printers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        printingProvider.printers[index].name!),
                                    CustomButton(
                                      buttonText: "Connect",
                                      onTap: () {
                                        printingProvider.connect(index);
                                      },
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).highlightColor,
                                  spreadRadius: 2),
                            ],
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  "Make sure to enable Bluetooth and Location services!",
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
            );
          }),
        ));
  }
}
