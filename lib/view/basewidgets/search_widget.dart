import 'package:flutter/material.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';

class SearchWidget extends StatefulWidget {
  final String? hintText;
  final Function? onTextChanged;
  final Function onClearPressed;
  final Function? onSubmit;
  final Function()? onTap;

  const SearchWidget({
    Key? key,
    required this.hintText,
    this.onTextChanged,
    required this.onClearPressed,
    this.onSubmit,
    this.onTap,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: "");
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        alignment: Alignment.center,
        child: Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                      bottomLeft:
                          Radius.circular(Dimensions.paddingSizeSmall))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: Dimensions.paddingSizeSmall,
                ),
                child: TextFormField(
                  controller: controller,
                  onFieldSubmitted: (query) {
                    widget.onSubmit!(query);
                  },
                  onChanged: (query) {
                    widget.onTextChanged!(query);
                  },
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: widget.hintText,
                      isDense: true,
                      hintStyle: robotoRegular.copyWith(
                          color: Theme.of(context).hintColor),
                      border: InputBorder.none,
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.black),
                              onPressed: () {
                                widget.onClearPressed();
                                controller.clear();
                              },
                            )
                          : null),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ]),
      ),
    ]);
  }
}
