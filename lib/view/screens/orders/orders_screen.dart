import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/order_model.dart';
import 'package:giftme/helper/date.dart';
import 'package:giftme/main.dart';
import 'package:giftme/provider/order_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
import 'package:giftme/view/screens/orders/order_details_screen.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderDetailsScreen(order: order)));
      },
      child: Container(
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
                Text(order.service!.title!, style: robotoBold.copyWith()),
                Row(
                  children: [
                    Text("Amount: ", style: robotoBold.copyWith()),
                    CustomPrice(price: order.price!)
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getDateFormatted(order.createdAt),
                    style: robotoBold.copyWith()),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: getStatusColor(order.status!),
                  ),
                  child: Text(order.status!,
                      style: robotoBold.copyWith(
                          color: Theme.of(context).canvasColor)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  getStatusColor(String s) {
    switch (s) {
      case "pending":
        return Colors.amber;
        break;
      case "completed":
        return Colors.green;
        break;
      case "rejected":
        return Colors.redAccent;
        break;
      default:
    }
  }
}
