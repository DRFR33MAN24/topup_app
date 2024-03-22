import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:giftme/provider/localization_provider.dart';
import 'package:giftme/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:giftme/data/model/response/category_model.dart' as cat;
import 'package:giftme/main.dart';
import 'package:giftme/provider/category_provider.dart';
import 'package:giftme/provider/profile_provider.dart';
import 'package:giftme/provider/splash_provider.dart';
import 'package:giftme/util/app_constants.dart';
import 'package:giftme/util/custom_themes.dart';
import 'package:giftme/util/dimensions.dart';
import 'package:giftme/util/images.dart';
import 'package:giftme/view/basewidgets/CustomPrice.dart';
import 'package:giftme/view/basewidgets/animated_custom_dialog.dart';
import 'package:giftme/view/basewidgets/category_widget.dart';
import 'package:giftme/view/basewidgets/sign_out_confirmation_dialog.dart';
import 'package:giftme/view/basewidgets/tag_widget.dart';
import 'package:giftme/view/screens/contact_us/contact_us_screen.dart';
import 'package:giftme/view/screens/profile/profile_screen.dart';
import 'package:giftme/view/screens/transactions/transactions_screen.dart';
import 'package:giftme/view/screens/transfer_balance/transfer_balance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController(text: "");

  late cat.Tag selectedTag;
  int offset = 1;
  Future<void> _loadData(bool reload) async {
    if (reload) {
      offset = 1;
    }
    await Provider.of<CategoryProvider>(Get.context!, listen: false)
        .getCategoryList('1', '', "", reload: reload);
    await Provider.of<CategoryProvider>(Get.context!, listen: false)
        .getTagsList();
  }

  @override
  void initState() {
    super.initState();

    _loadData(false);

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
            print('dbg end of the page ${offset} ${pageSize}');
          }
          Provider.of<CategoryProvider>(context, listen: false)
              .showBottomLoader();

          Provider.of<CategoryProvider>(context, listen: false)
              .getCategoryList(offset.toString(), "", "", reload: false);
        }
      }
    });
  }

  var key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: AppDrawer(),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await _loadData(true);
        },
        child: Stack(children: [
          CustomScrollView(
            // controller: _scrollController,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ContactUs()));
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
                          Map<cat.Tag, bool> tagsMap;
                          categoryList = categoryProvider.categoryList;
                          tagsMap = categoryProvider.tagsToggleMap;

                          return Column(children: [
                            BalanceWidget(),
                            Divider(),
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
                                        cat.Tag buttonIndexTag =
                                            tagsMap.keys.toList()[buttonIndex];
                                        if (buttonIndex == index) {
                                          if (buttonIndexTag.tag == "Finance") {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        TransferBalance()));
                                          } else {
                                            Provider.of<CategoryProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .getCategoryList(
                                                    '1', buttonIndexTag.tag, "",
                                                    reload: true);
                                          }
                                          tagsMap.update(
                                              buttonIndexTag, (value) => true);
                                          selectedTag = buttonIndexTag;
                                        } else {
                                          tagsMap.update(
                                              buttonIndexTag, (value) => false);
                                        }
                                      }
                                    });
                                  },
                                  children: tagsMap.keys
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IgnorePointer(
                                                child: TagWidget(
                                                    tag: e,
                                                    isSelected: tagsMap[e])),
                                          ))
                                      .toList()),
                            ),
                            Divider(),
                            Stack(children: [
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
                                              topLeft: Radius.circular(
                                                  Dimensions.paddingSizeSmall),
                                              bottomLeft: Radius.circular(
                                                  Dimensions.paddingSizeSmall),
                                              bottomRight: Radius.circular(
                                                  Dimensions.paddingSizeSmall),
                                              topRight: Radius.circular(
                                                  Dimensions
                                                      .paddingSizeSmall))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.paddingSizeSmall,
                                          horizontal:
                                              Dimensions.paddingSizeSmall,
                                        ),
                                        child: TextFormField(
                                          controller: controller,
                                          onFieldSubmitted: (query) {},
                                          onChanged: (query) {
                                            Provider.of<CategoryProvider>(
                                                    Get.context!,
                                                    listen: false)
                                                .getCategoryList('1', '', query,
                                                    reload: true);
                                          },
                                          textInputAction:
                                              TextInputAction.search,
                                          maxLines: 1,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              hintText: "Search here...",
                                              isDense: true,
                                              hintStyle: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              border: InputBorder.none,
                                              suffixIcon: controller
                                                      .text.isNotEmpty
                                                  ? IconButton(
                                                      icon: const Icon(
                                                          Icons.clear,
                                                          color: Colors.black),
                                                      onPressed: () {
                                                        controller.clear();
                                                        Provider.of<CategoryProvider>(
                                                                Get.context!,
                                                                listen: false)
                                                            .getCategoryList(
                                                                '1', "", "",
                                                                reload: true);
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
                            ]),
                            categoryList.isNotEmpty
                                ? SizedBox(
                                    height: Dimensions.cardHeight,
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        _loadData(true);
                                      },
                                      child: StaggeredGridView.countBuilder(
                                        controller: _scrollController,
                                        itemCount: categoryList.length,
                                        crossAxisCount: 3,
                                        padding: const EdgeInsets.all(0),
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: false,
                                        staggeredTileBuilder: (int index) =>
                                            const StaggeredTile.fit(1),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CategoryWidget(
                                              category: categoryList[index]);
                                          // return SizedBox();
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
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

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({
    super.key,
  });

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).cardColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0) //
            ),
      ),
      child: Consumer<ProfileProvider>(builder: (context, profile, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Current Balance",
                  style: robotoRegular,
                ),
                SizedBox(
                  height: 10,
                ),
                profile.balance != null
                    ? CustomPrice(price: profile.balance!.toString())
                    : CustomPrice(price: "0.0")
              ],
            ),
            Column(
              children: [
                Text(
                  "LBP",
                  style: robotoBold,
                ),
                RotatedBox(
                    quarterTurns: 1,
                    child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          if (value) {
                            Provider.of<SplashProvider>(context, listen: false)
                                .changeCurrency("USD");
                          } else {
                            Provider.of<SplashProvider>(context, listen: false)
                                .changeCurrency("LBP");
                          }
                          setState(() {
                            isSwitched = value;
                          });
                        })),
                Text("USD", style: robotoBold)
              ],
            )
          ],
        );
      }),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Consumer<ProfileProvider>(builder: (context, profile, child) {
      return ListView(children: [
        DrawerHeader(
            child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                width: Dimensions.profileImageSize,
                height: Dimensions.profileImageSize,
                fit: BoxFit.cover,
                image:
                    '${AppConstants.baseUrl}\\storage\\profile\\${profile.userInfoModel!.image}',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                    width: Dimensions.profileImageSize,
                    height: Dimensions.profileImageSize,
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: profile.userInfoModel!.fName != null
                  ? Text(profile.userInfoModel!.fName! +
                      " " +
                      profile.userInfoModel!.lName!)
                  : null,
            )
          ],
        )),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
          title: Text("My Profile"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.money,
            color: Theme.of(context).primaryColor,
          ),
          title: Text("Transactions"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => TransactionsScreen()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.contact_support,
            color: Theme.of(context).primaryColor,
          ),
          title: Text("Contact Us"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ContactUs()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person_remove,
            color: Theme.of(context).primaryColor,
          ),
          title: Text("Delete Account"),
          onTap: () => showAnimatedDialog(
              context,
              SignOutConfirmationDialog(
                isDelete: true,
                customerId: profile.userInfoModel!.id,
              ),
              isFlip: true),
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).primaryColor,
          ),
          title: Text("Log Out"),
          onTap: () => showAnimatedDialog(
              context,
              SignOutConfirmationDialog(
                isDelete: false,
                customerId: profile.userInfoModel!.id,
              ),
              isFlip: true),
        ),
        ListTile(
          leading: Icon(
            Icons.language,
            color: Theme.of(context).primaryColor,
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Language",
            ),
            Switch(
                value: Provider.of<LocalizationProvider>(Get.context!,
                        listen: false)
                    .isLtr,
                onChanged: (value) {
                  if (value) {
                    Provider.of<LocalizationProvider>(Get.context!,
                            listen: false)
                        .setLanguage(Locale("ar"));
                  } else {
                    Provider.of<LocalizationProvider>(Get.context!,
                            listen: false)
                        .setLanguage(Locale("en"));
                  }
                })
          ]),
        ),
        ListTile(
          leading: Icon(
            Icons.dark_mode,
            color: Theme.of(context).primaryColor,
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Dark Mode",
            ),
            Switch(
                value: Provider.of<ThemeProvider>(Get.context!, listen: false)
                    .darkTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(Get.context!, listen: false)
                      .toggleTheme();
                })
          ]),
        ),
      ]);
    }));
  }
}
