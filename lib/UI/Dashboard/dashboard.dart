import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:food_inventory/UI/DeliverySettings/deliverySettings.dart';
import 'package:food_inventory/UI/Offer/offer_discount.dart';
import 'package:food_inventory/UI/RestaurantDetails/restaurantDetails.dart';
import 'package:food_inventory/UI/instantAction/instant_action.dart';
import 'package:food_inventory/UI/menu/menu.dart';
import 'package:food_inventory/UI/order/order.dart';
import 'package:food_inventory/UI/restaurentTimeSet/restaurantTimeSet.dart';
import 'package:food_inventory/UI/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/colors.dart';
import '../../constant/const.dart';
import '../../constant/image.dart';
import '../../constant/utils.dart';
import '../Login/login.dart';
import '../itemsTimeSet/itemsTimeSet.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  int _selectedDrawerIndex = 0, _checkPage = 0;
  // final List<int> _backstack = [0];
  List<int> mOriginaListMain = [0];

  late GifController controller;

  late Widget avatarWidget;

  late SharedPreferences _prefs;
  var _items = [
    "Nameste India",
    "Nameste India",
    "Nameste India",
    "Nameste India",
    "Nameste India",
    "Nameste India",
    "Nameste India",
    "Nameste India",
    "Nameste India"
  ];
  String id = '',
      userName = '',
      mobileNo = '',
      profileImage = '',
      firstName = '',
      lastName = '';

  @override
  void initState() {
    // List view;
    // Scheduleblocking();

    initPreferences();

    avatarWidget = Container();
    controller = GifController(vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // controller.repeat(min: 0, max: 22, period: Duration(milliseconds: 1500));
      controller.value = 0;
      controller.animateTo(22, duration: const Duration(milliseconds: 1500));
    });

    super.initState();
  }

  var notiCount;
  initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Order();
      case 1:
        return new InstantAction();
      case 2:
        return new OfferDiscount();
      case 3:
        return new Menu();
      case 4:
        return new ItemsTimeSet();
      case 5:
        return new RestaurantTimeSet();
      case 6:
        return new DeliverySetting();
      case 7:
        return new RestaurantDetails();
      case 8:
        return new Settings();
    }
  }

  _onSelectItem(int index) {
    if (index == 0 || index == 1) {
      avatarWidget = Container();
    } else {
      avatarWidget = avatar();
    }

    List<String> mList =
        (_prefs.getStringList(Constants.backPages) ?? <String>[]);

    mOriginaListMain = mList.map((i) => int.parse(i)).toList();

    // if (!_backstack.contains(arguments['page'])) {
    //   _backstack.add(arguments['page']);
    // }

    if (!mOriginaListMain.contains(index)) {
      mOriginaListMain.add(index);

      List<String> stringsList =
          mOriginaListMain.map((i) => i.toString()).toList();

      _prefs.setStringList(Constants.backPages, stringsList);
    }

    setState(() => _selectedDrawerIndex = index);

    Navigator.of(context).pop(); // close the drawer
  }

  Future<bool> customPop(BuildContext context) async {
    print("CustomPop is called");
    print("_backstack = $mOriginaListMain");

    List<String> mList =
        (_prefs.getStringList(Constants.backPages) ?? <String>[]);

    List<int> mOriginaList = mList.map((i) => int.parse(i)).toList();

    if (mOriginaList.length > 1) {
      mOriginaList.removeAt(mOriginaList.length - 1);
      navigateBack(mOriginaList[mOriginaList.length - 1]);

      List<String> stringsList = mOriginaList.map((i) => i.toString()).toList();

      _prefs.setStringList(Constants.backPages, stringsList);

      return Future.value(false);
    } else {
      return _onWillPop();
    }

    // if (_backstack.length > 1) {
    //   _backstack.removeAt(_backstack.length - 1);
    //   navigateBack(_backstack[_backstack.length - 1]);

    //   return Future.value(false);
    // } else {
    //   return _onWillPop();
    // }
  }

  void navigateBack(int index) {
    if (index == 0 || index == 1) {
      avatarWidget = Container();
    } else {
      avatarWidget = avatar();
    }
    setState(() {
      _selectedDrawerIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: new Text('Are you sure you want to exit?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No',
                    style: TextStyle(
                        color: Colors.lightBlue.shade700,
                        fontWeight: FontWeight.bold)),
              ),
              new FlatButton(
                onPressed: () async {
                  // Utils.hideLoader(context);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: new Text('Yes',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null && _checkPage != -1) {
      SharedPreferences.getInstance().then((value) {
        List<String> mList =
            (value.getStringList(Constants.backPages) ?? <String>[]);

        List<int> mOriginaList = mList.map((i) => int.parse(i)).toList();

        // if (!_backstack.contains(arguments['page'])) {
        //   _backstack.add(arguments['page']);
        // }
        //
        if (!mOriginaList.contains(arguments['page'])) {
          mOriginaList.add(arguments['page']);
        }

        setState(() {
          _selectedDrawerIndex = arguments['page'];

          _checkPage = -1;
        });

        List<String> stringsList =
            mOriginaList.map((i) => i.toString()).toList();

        value.setStringList(Constants.backPages, stringsList);

        return true;
      });
    }

    return WillPopScope(
      onWillPop: () {
        return customPop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: SafeArea(
          child: Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(15.0),
            //       bottomRight: Radius.circular(15.0)),
            //   color: colorButtonBlue,
            // ),
            width: MediaQuery.of(context).size.width / 1.4,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3.0,
                sigmaY: 3.0,
              ),
              child: Drawer(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0)),
                ),
                elevation: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    color: colorButtonBlue,
                  ),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 0, right: 0),
                          child: const Divider(color: Colors.black)),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              drawerItem(
                                "Order",
                                icOrder,
                                0,
                              ),
                              drawerItem(
                                'Instant Action',
                                icAction,
                                1,
                              ),
                              drawerItem(
                                "Offer/Discount",
                                icOffer,
                                2,
                              ),
                              drawerItem(
                                'Menu',
                                icMenu,
                                3,
                              ),
                              drawerItem(
                                "Items Time Set",
                                icDetails,
                                4,
                              ),
                              drawerItem(
                                'Restaurant Time Set',
                                icMenu,
                                5,
                              ),
                              drawerItem(
                                "Delivery Settings",
                                icDelSetting,
                                6,
                              ),
                              drawerItem(
                                'Restaurant Details',
                                icDetails,
                                7,
                              ),
                              drawerItem(
                                "Settings",
                                icSetting,
                                8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: 10, top: 15, left: 5),
                        color: colorButtonBlue,
                        child: GestureDetector(
                          child: Container(
                            // color: colorButtonBlue,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  icLogOut,
                                  color: colorButtonYellow,
                                  height: 18,
                                  width: 11.25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            margin: const EdgeInsets.only(left: 20),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            logoutDialog();
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, top: 15, left: 25),
                        child: Text(
                          "Version 0.1",
                          style: TextStyle(
                              color: colorTextWhite.withOpacity(0.50),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Builder(
          builder: (BuildContext context) => SafeArea(
            maintainBottomViewPadding: true,
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, top: 05, bottom: 05, right: 10),
                  color: colorButtonBlue,
                  child: Row(children: [
                    Center(
                      child: Container(
                        child: FlatButton(
                          minWidth: 20,
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            icMenuHam,
                          ),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            Scaffold.of(context).openDrawer();
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              // controller.repeat(min: 0, max: 22, period: Duration(milliseconds: 1500));
                              controller.value = 0;
                              controller.animateTo(22,
                                  duration: const Duration(milliseconds: 1500));
                            });
                          },
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        // color:Colors.yellow,
                        // width: MediaQuery.of(context).size.width / 1.8,
                        child: Text(
                          '${_items[_selectedDrawerIndex]}',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                              color: colorTextWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      "14 June, 2021",
                      style: TextStyle(
                          color: colorTextWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      child: SvgPicture.asset(
                        icCalendar,
                        height: MediaQuery.of(context).size.height * 0.021,
                        width: MediaQuery.of(context).size.width * 0.021,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      child: SvgPicture.asset(
                        icDashRate,
                        height: MediaQuery.of(context).size.height * 0.021,
                        width: MediaQuery.of(context).size.width * 0.021,
                        color: colorTextWhite,
                      ),
                    ),
                    // _selectedDrawerIndex
                  ]),
                ),
                Expanded(child: _getDrawerItemWidget(_selectedDrawerIndex)),
                // _selectedDrawerIndex=4
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget avatar() {
    return InkWell(
      child: Hero(
        tag: 'avatar',
        child: Card(
          // shape: CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage('assets/patient.png')),
          ),
        ),
      ),
    );
  }

  Widget drawerItem(String title, String assetName, int pageIndex) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        if (pageIndex == 0) {
          mOriginaListMain.clear();
        }
        if (pageIndex != -1) {
          _onSelectItem(pageIndex);
        }
        print("Page Data: " + pageIndex.toString());
        // });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.circle,
                        size: 52, color: colorGrey.withOpacity(0.30)),
                    SvgPicture.asset(
                      assetName,
                      height: 20,
                      width: 15.23,
                      color: colorTextWhite,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 15),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: colorTextWhite,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (popupContext) {
        Widget content = const Text("Are you sure you want to logout?");
        List<Widget> action = [
          TextButton(
            onPressed: () {
              Navigator.pop(popupContext);
            },
            child: const Text(
              'No',
              style: TextStyle(color: colorTextBlack),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(popupContext);
            },
            child: const Text('Yes',
                style: const TextStyle(color: colorButtonBlue)),
          ),
        ];

        return Platform.isIOS
            ? CupertinoAlertDialog(
                content: content,
                actions: action,
              )
            : AlertDialog(
                content: content,
                actions: action,
              );
      },
    );
  }
}
