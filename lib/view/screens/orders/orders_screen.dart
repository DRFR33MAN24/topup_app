import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/data/model/response/order_model.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/order_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/view/basewidgets/CustomPrice.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int offset = 1;
  DateTime selectedDate = DateTime.now();
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
            actions: [
              GestureDetector(
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000));

                  if (date != null) {
                    await Provider.of<OrderProvider>(Get.context!,
                            listen: false)
                        .getOrdersList('1', date.toIso8601String(),
                            reload: true);
                  }
                },
                child: Container(
                    margin: EdgeInsets.all(8),
                    child: Icon(
                      Icons.date_range,
                      size: 32,
                      color: Theme.of(context).canvasColor,
                    )),
              )
            ],
          ),
          body:
              Consumer<OrderProvider>(builder: (context, orderProvider, child) {
            return ListView.builder(
              itemCount: orderProvider.ordersList.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderWidget(order: orderProvider.ordersList[index]);
              },
            );
          }),
        ));
  }
}

class OrderWidget extends StatelessWidget {
  final Order order;
  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(color: Theme.of(context).disabledColor, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Order Type"),
              Row(
                children: [Text("amount"), CustomPrice(price: order.price!)],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("15/15/21"),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).disabledColor,
                        spreadRadius: 1),
                  ],
                ),
                child: Text(order.status!,
                    style: robotoBold.copyWith(
                        color: Theme.of(context).canvasColor)),
              )
            ],
          )
        ],
      ),
    );
  }
}
