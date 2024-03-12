import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/data/model/response/payment_model.dart';
import 'package:stylizeit/provider/payment_provider.dart';
import 'package:stylizeit/provider/splash_provider.dart';
import 'package:stylizeit/provider/theme_provider.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';
import 'package:stylizeit/view/basewidgets/button/custom_button.dart';
import 'package:stylizeit/view/screens/cashout/widget/custom_check_box.dart';
import 'package:stylizeit/view/screens/dashboard/dashboard_screen.dart';
import 'package:stylizeit/view/screens/payment/payment_screen.dart';

class CashoutScreen extends StatefulWidget {
  final Package package;
  const CashoutScreen({Key? key, required this.package}) : super(key: key);

  @override
  _CashoutScreenState createState() => _CashoutScreenState();
}

class _CashoutScreenState extends State<CashoutScreen> {
  @override
  Widget build(BuildContext context) {
    List<PaymentMethod> paymentMethods = [
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .bkash!)
        PaymentMethod('bkash', Images.bKash),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .liqpay!)
        PaymentMethod('liqpay', Images.liqpay),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .mercadopago!)
        PaymentMethod('mercadopago', Images.mercadopago),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .paymobAccept!)
        PaymentMethod('paymob_accept', Images.paymob),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .paystack!)
        PaymentMethod('paystack', Images.paystack),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .paytabs!)
        PaymentMethod('paytabs', Images.paytabs),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .razorPay!)
        PaymentMethod('razor_pay', Images.razorpay),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .paypal!)
        PaymentMethod('paypal', Images.paypal),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .senangPay!)
        PaymentMethod('senang_pay', Images.snangpay),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .sslCommerzPayment!)
        PaymentMethod('ssl_commerz_payment', Images.sslCommerz),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .stripe!)
        PaymentMethod('stripe', Images.stripe),
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .paymentMethods!
          .fawryPay!)
        PaymentMethod('fawry_pay', Images.fawryPay),
    ];
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(children: [
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text('Cashout',
                  style: robotoRegular.copyWith(
                      fontSize: 20, color: Theme.of(context).cardColor)),
            ]),
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
          body: Container(
            child: ListView.builder(
              itemCount: paymentMethods.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CustomCheckBox(
                    index: index,
                    name: paymentMethods[index].name,
                    icon: paymentMethods[index].image);
              },
            ),
          ),
          bottomSheet: CustomButton(
            buttonText: "Complete Payment",
            onTap: () {
              var paymentMethodIndex =
                  Provider.of<PyamentProvider>(context).paymentMethodIndex;
              var credit_bundle_id = widget.package.id.toString();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PaymentScreen(
                        paymentMethod: paymentMethodIndex.toString(),
                        credit_bundle_id: credit_bundle_id,
                      )));
            },
          ),
        ));
  }
}

class PaymentMethod {
  String name;
  String image;
  PaymentMethod(this.name, this.image);
}
