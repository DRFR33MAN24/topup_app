import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/transaction_model.dart';
import 'package:giftme/helper/date.dart';
import 'package:giftme/main.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:giftme/provider/tranaction_provider.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
import 'package:shimmer/shimmer.dart';

import '../../../util/color_resources.dart';
import '../../basewidgets/no_data.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int offset = 1;
  DateTime selectedDate = DateTime.now();
  Future<void> loadData(bool reload) async {
    if (reload) {
      offset = 1;
    }
    await Provider.of<TransactionProvider>(Get.context!, listen: false)
        .getTransactionList('1', '', reload: reload);
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
              Text('Transactions',
                  style: robotoRegular.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
            actions: [
              GestureDetector(
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000));

                  if (date != null) {
                    await Provider.of<TransactionProvider>(Get.context!,
                            listen: false)
                        .getTransactionList('1', date.toIso8601String(),
                            reload: true);
                  }
                },
                child: Container(
                    margin: EdgeInsets.all(8),
                    child: Icon(
                      Icons.date_range,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await loadData(true);
            },
            child: Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
              return !transactionProvider.isLoading
                  ? transactionProvider.transactionList.isNotEmpty
                      ? ListView.builder(
                          itemCount: transactionProvider.transactionList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TransactionWidget(
                                trx:
                                    transactionProvider.transactionList[index]);
                          },
                        )
                      : NoDataWidget(onRefresh: () async {
                          await loadData(true);
                        })
                  : TransactionsShimmer();
            }),
          ),
        ));
  }
}

class TransactionWidget extends StatelessWidget {
  final Transaction trx;
  const TransactionWidget({super.key, required this.trx});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(color: Theme.of(context).disabledColor, spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ID: " + trx.trx_id!, style: robotoBold.copyWith()),
              Text("Date: " + getDateFormatted(trx.createdAt),
                  style: robotoBold.copyWith()),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Amount: ", style: robotoBold.copyWith()),
              Text(
                "${trx.amount!}${trx.currency}",
                style: robotoBold.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: [
              Text("Note: " + trx.remarks!),
            ],
          )
        ],
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

class TransactionsShimmer extends StatelessWidget {
  const TransactionsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          color: ColorResources.getGrey(context),
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.surface,
            highlightColor: Colors.grey[200]!,
            enabled: Provider.of<TransactionProvider>(context).isLoading,
            child: ListTile(
              title: Container(height: 20, color: ColorResources.white),
              subtitle:
                  Container(height: 10, width: 50, color: ColorResources.white),
            ),
          ),
        );
      },
    );
  }
}
