import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/screens/cashout/cashout_screen.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
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
              Text('Balance Transfer',
                  style: robotoRegular.copyWith(
                      fontSize: 20, color: Theme.of(context).cardColor)),
            ]),
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
          body: Consumer<PyamentProvider>(
              builder: (context, paymentProvider, child) {
            return Card(
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("Support:"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.chat,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("Whatsapp:"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("Email:"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
