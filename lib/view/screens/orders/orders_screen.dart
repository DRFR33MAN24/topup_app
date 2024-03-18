import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/order_provider.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/screens/cashout/cashout_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int offset = 1;
  Future<void> loadData(bool reload) async {
    if (reload) {
      offset = 1;
    }
    await Provider.of<OrderProvider>(Get.context!, listen: false)
        .getOrdersList('1', '', reload: reload);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData(true);
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
              Text('Orders',
                  style: robotoRegular.copyWith(
                      fontSize: 20, color: Theme.of(context).cardColor)),
            ]),
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
          body:
              Consumer<OrderProvider>(builder: (context, orderProvider, child) {
            return ListView.builder(
              itemCount: orderProvider.ordersList.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderWidget();
              },
            );
          }),
        ));
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Theme.of(context).disabledColor, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Order Type"), Text("amount")],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("15/15/21"),
              Container(
                color: Theme.of(context).primaryColor,
                child: Text("Status"),
              )
            ],
          )
        ],
      ),
    );
  }
}
