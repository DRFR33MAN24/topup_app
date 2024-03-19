import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/provider/tranaction_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';

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
                      color: Theme.of(context).canvasColor,
                    )),
              )
            ],
          ),
          body: Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
            return ListView.builder(
              itemCount: transactionProvider.transactionList.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionWidget();
              },
            );
          }),
        ));
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
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
