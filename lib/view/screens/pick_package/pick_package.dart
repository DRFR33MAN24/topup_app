import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/screens/cashout/cashout_screen.dart';

class PickPackage extends StatefulWidget {
  const PickPackage({Key? key}) : super(key: key);

  @override
  _PickPackageState createState() => _PickPackageState();
}

class _PickPackageState extends State<PickPackage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await Provider.of<PyamentProvider>(Get.context!, listen: false)
        .getPackages();
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
              Text('Pick Package',
                  style: robotoRegular.copyWith(
                      fontSize: 20, color: Theme.of(context).cardColor)),
            ]),
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
          body: Consumer<PyamentProvider>(
              builder: (context, paymentProvider, child) {
            return paymentProvider.packages != null
                ? ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: paymentProvider.packages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 150,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(paymentProvider.packages[index].name!),
                          ),
                          Expanded(
                            child: Text(paymentProvider.packages[index].amount
                                .toString()),
                          ),
                          CustomButton(
                            buttonText: "Buy Package!",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CashoutScreen(
                                        package:
                                            paymentProvider.packages[index],
                                      )));
                            },
                          ),
                        ],
                      );
                    })
                : SizedBox();
          }),
        ));
  }
}
