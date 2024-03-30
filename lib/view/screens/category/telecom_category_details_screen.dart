import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/category_model.dart' as cat;
import 'package:giftme/provider/auth_provider.dart';
import 'package:giftme/provider/order_provider.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
import 'package:giftme/view/basewidgets/animated_custom_dialog.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';
import 'package:giftme/view/basewidgets/order_confirmation_dialog.dart';
import 'package:giftme/view/basewidgets/service_widget.dart';

class TelecomCategoryDetailsScreen extends StatefulWidget {
  final cat.Category category;

  const TelecomCategoryDetailsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _TelecomCategoryDetailsScreenState createState() =>
      _TelecomCategoryDetailsScreenState();
}

class _TelecomCategoryDetailsScreenState
    extends State<TelecomCategoryDetailsScreen> {
  late Map<cat.Service, bool> servicesMap;
  late cat.Service selectedService;

  TextEditingController qty = TextEditingController();
  TextEditingController player_id = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicesMap = Map.fromEntries(
        widget.category.services!.map((e) => MapEntry(e, false)));

    servicesMap.update(servicesMap.keys.first, (value) => true);
    selectedService = servicesMap.keys.first;
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
              title: Text(widget.category.title!),
              backgroundColor: Theme.of(context).primaryColor),
          body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                SizedBox(
                    height: Dimensions.cardHeight * 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StaggeredGridView.countBuilder(
                        // controller: _scrollController,
                        itemCount: widget.category.services!.length,
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(0),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: false,
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                        itemBuilder: (BuildContext context, int index) {
                          return ServiceWidget(
                            service: widget.category.services![index],
                            isSelected: false,
                            isTelecom: true,
                          );
                          // return SizedBox();
                        },
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
          ),
        ));
  }

  placeOrder() {
    // Provider.of<OrderProvider>(context, listen: false).placeOrder(
    //   '1',
    //   Provider.of<AuthProvider>(context, listen: false).getUserToken(),
    // );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  late final int min;
  late final int max;

  CustomRangeTextInputFormatter(int this.min, int this.max);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < min)
      return TextEditingValue().copyWith(text: min.toString());

    return int.parse(newValue.text) > max
        ? TextEditingValue().copyWith(text: max.toString())
        : newValue;
  }
}
