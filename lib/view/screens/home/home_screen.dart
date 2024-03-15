import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylizeit/data/model/response/category_model.dart' as cat;
import 'package:stylizeit/main.dart';
import 'package:stylizeit/provider/category_provider.dart';
import 'package:stylizeit/provider/style_provider.dart';
import 'package:stylizeit/util/color_resources.dart';
import 'package:stylizeit/util/custom_themes.dart';
import 'package:stylizeit/util/dimensions.dart';
import 'package:stylizeit/util/images.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stylizeit/view/basewidgets/category_widget.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _loadData(bool reload) async {
    await Provider.of<CategoryProvider>(Get.context!, listen: false)
        .getCategoryList('1', '', reload: reload);
    await Provider.of<CategoryProvider>(Get.context!, listen: false)
        .getTagsList();
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
          Provider.of<CategoryProvider>(context, listen: false)
              .categoryList
              .isNotEmpty &&
          !Provider.of<CategoryProvider>(context, listen: false).isLoading) {
        int? pageSize;

        pageSize =
            Provider.of<CategoryProvider>(context, listen: false).pageSize;

        if (offset < pageSize!) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<CategoryProvider>(context, listen: false)
              .showBottomLoader();

          Provider.of<CategoryProvider>(context, listen: false)
              .getCategoryList(offset.toString(), null);
        }
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
              child: Column(
            children: const [
              CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage(Images.homeImage),
              ),
              Text("name")
            ],
          )),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("My Profile"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.money,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Transactions"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.contact_support,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Contact Us"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.person_remove,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Delete Account"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Log Out"),
            onTap: () {},
          )
        ]),
      ),
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
                title: IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  icon: Row(children: [
                    Icon(
                      Icons.list,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    )
                  ]),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PickPackage()));
                    },
                    icon: Row(children: [
                      Icon(
                        Icons.notifications,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      )
                    ]),
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
                      child: Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          List<cat.Category> categoryList;
                          Map<String, bool> tagsMap;
                          categoryList = categoryProvider.categoryList;
                          tagsMap = categoryProvider.tagsToggleMap;

                          return Column(children: [
                            Container(
                              width: 250,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).cardColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0) //
                                    ),
                              ),
                            ),
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
                                            Provider.of<CategoryProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .getCategoryList('1', '',
                                                    reload: true);
                                          } else {
                                            Provider.of<CategoryProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .getCategoryList(
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
                            !categoryProvider.isLoading
                                ? categoryList.isNotEmpty
                                    ? SizedBox(
                                        height: Dimensions.cardHeight,
                                        child: StaggeredGridView.countBuilder(
                                          itemCount: categoryList.length,
                                          crossAxisCount: 3,
                                          padding: const EdgeInsets.all(0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: false,
                                          staggeredTileBuilder: (int index) =>
                                              const StaggeredTile.fit(1),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CategoryWidget(
                                                category: categoryList[index]);
                                            // return SizedBox();
                                          },
                                        ),
                                      )
                                    : const SizedBox.shrink()
                                : StyleShimmer(
                                    isEnabled: categoryProvider.isLoading),
                            categoryProvider.isLoading
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
