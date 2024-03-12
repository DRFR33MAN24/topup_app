import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/data/model/response/style_model.dart';
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/style_provider.dart';
import 'package:stylizeit/util/color_resources.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stylizeit/view/basewidgets/style_shimmer.dart';
import 'package:stylizeit/view/basewidgets/style_widget.dart';
import 'package:stylizeit/view/screens/cashout/cashout_screen.dart';
import 'package:stylizeit/view/screens/dashboard/dashboard_screen.dart';
import 'package:stylizeit/view/screens/pick_package/pick_package.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadData(bool reload) async {
    await Provider.of<StyleProvider>(Get.context!, listen: false)
        .getStyleList('1', '', reload: reload);
    await Provider.of<StyleProvider>(Get.context!, listen: false).getTagsList();
  }

  @override
  void initState() {
    super.initState();

    _loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels &&
          Provider.of<StyleProvider>(context, listen: false)
              .styleList
              .isNotEmpty &&
          !Provider.of<StyleProvider>(context, listen: false).isLoading) {
        int? pageSize;

        pageSize = Provider.of<StyleProvider>(context, listen: false).pageSize;

        if (offset < pageSize!) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<StyleProvider>(context, listen: false).showBottomLoader();

          Provider.of<StyleProvider>(context, listen: false)
              .getStyleList(offset.toString(), null);
        }
      }
    });

    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await _loadData(true);
        },
        child: Stack(children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).cardColor,
                title: Image.asset(Images.logoWithNameImage, height: 35),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PickPackage()));
                      },
                      icon: Row(children: [
                        Image.asset(
                          Images.coins,
                          height: Dimensions.iconSizeDefault,
                          width: Dimensions.iconSizeDefault,
                          color: ColorResources.getPrimary(context),
                        ),
                        Text("1000000",
                            style: titilliumSemiBold.copyWith(
                              color: ColorResources.getPrimary(context),
                              fontSize: Dimensions.fontSizeExtraSmall,
                            )),
                      ]),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Dimensions.homePagePadding,
                          Dimensions.paddingSizeSmall,
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeSmall),
                      child: Consumer<StyleProvider>(
                        builder: (context, styleProvider, child) {
                          List<Style> styleList;
                          Map<String, bool> tagsMap;
                          styleList = styleProvider.styleList;
                          tagsMap = styleProvider.tagsToggleMap;

                          return Column(children: [
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: ToggleButtons(
                                  isSelected: tagsMap.values.toList(),
                                  renderBorder: false,
                                  fillColor: Colors.transparent,
                                  borderColor: Theme.of(context).primaryColor,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int buttonIndex = 0;
                                          buttonIndex < tagsMap.length;
                                          buttonIndex++) {
                                        String buttonIndexStr =
                                            tagsMap.keys.toList()[buttonIndex];
                                        if (buttonIndex == index) {
                                          if (buttonIndexStr == "All") {
                                            Provider.of<StyleProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .getStyleList('1', '',
                                                    reload: true);
                                          } else {
                                            Provider.of<StyleProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .getStyleList(
                                                    '1', buttonIndexStr,
                                                    reload: true);
                                          }
                                          tagsMap.update(
                                              buttonIndexStr, (value) => true);
                                        } else {
                                          tagsMap.update(
                                              buttonIndexStr, (value) => false);
                                        }
                                      }
                                    });
                                  },
                                  children: tagsMap.keys
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  border: Border.all(
                                                    width: 1.0,
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              5.0) //
                                                          ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .cardColor),
                                                )),
                                          ))
                                      .toList()),
                            ),
                            !styleProvider.isLoading
                                ? styleList.isNotEmpty
                                    ? SizedBox(
                                        height: Dimensions.cardHeight,
                                        child: StaggeredGridView.countBuilder(
                                          itemCount: styleList.length,
                                          crossAxisCount: 2,
                                          padding: const EdgeInsets.all(0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          staggeredTileBuilder: (int index) =>
                                              const StaggeredTile.fit(1),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return StyleWidget(
                                                style: styleList[index]);
                                            // return SizedBox();
                                          },
                                        ),
                                      )
                                    : const SizedBox.shrink()
                                : StyleShimmer(
                                    isEnabled: styleProvider.isLoading),
                            styleProvider.isLoading
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.iconSizeExtraSmall),
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor)),
                                  ))
                                : const SizedBox.shrink(),
                          ]);
                        },
                      ))),
            ],
          )
        ]),
      )),
    );
  }
}
