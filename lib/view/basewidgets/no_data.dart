import 'package:flutter/material.dart';
import 'package:giftme/view/basewidgets/button/custom_button.dart';

class NoDataWidget extends StatelessWidget {
  final Function onRefresh;
  const NoDataWidget({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/no_data.png',
            height: 150,
            width: 150,
          ),
        ),
        Text("no data..."),
        Container(
          margin: EdgeInsets.all(40),
          child: CustomButton(
            buttonText: "Refresh",
            onTap: () => onRefresh(),
          ),
        )
      ],
    );
  }
}
