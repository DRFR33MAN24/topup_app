import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/order_model.dart';
import 'package:giftme/helper/date.dart';
import 'package:giftme/main.dart';
import 'package:giftme/provider/payment_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
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
                Text('Order Details',
                    style: robotoRegular.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface)),
              ]),
              backgroundColor: Theme.of(context).colorScheme.background),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order ID: ", style: robotoBold.copyWith()),
                            Text(widget.order.id!.toString(),
                                style: robotoBold.copyWith())
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Quantity: ", style: robotoBold.copyWith()),
                            Text(widget.order.qty!.toString(),
                                style: robotoBold.copyWith())
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Status: ", style: robotoBold.copyWith()),
                            Text(widget.order.status!.toString(),
                                style: robotoBold.copyWith())
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Service: ", style: robotoBold.copyWith()),
                            Flexible(
                              child: Text(widget.order.service!.title!,
                                  style: robotoBold.copyWith()),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date: ", style: robotoBold.copyWith()),
                            Text(getDateFormatted(widget.order.createdAt!),
                                style: robotoBold.copyWith())
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Amount: ", style: robotoBold.copyWith()),
                            CustomPrice(price: widget.order.price!)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Result ",
                                style: robotoBold.copyWith(fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: widget.order.reason!));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          content: Text("Result copied!"),
                                          backgroundColor: Colors.green));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(8),
                                  color: Theme.of(context).canvasColor,
                                  child: Icon(
                                    Icons.copy,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          widget.order.reason != null
                              ? Html(
                                  data: widget.order.reason!,
                                )
                              : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(child: Text('NO Result!')),
                                )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
