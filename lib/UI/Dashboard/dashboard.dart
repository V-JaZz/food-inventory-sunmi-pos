// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/app_util.dart';
import '../../constant/colors.dart';
import '../../constant/const.dart';
import '../../constant/image.dart';
import '../../constant/storage_util.dart';
import '../../constant/validation_util.dart';
import '../OrderHistory/orderHistory.dart';
import '../itemsTimeSet/itemsTimeSet.dart';
import '../order/model/order_list_response_model.dart';
import 'forms/Allergy/add_new_allergy.dart';
import 'forms/AllergyGroup/add_allergyGroup.dart';
import 'forms/Category/add_new_category.dart';
import 'forms/Items/dialogMenu.dart';
import 'forms/Option/add_option.dart';
import 'forms/Toppings/add_topping.dart';
import 'forms/Varient/add_new_varient.dart';
import 'forms/VarientGroup/add_varientGroup.dart';
import 'forms/toppingGroup/add_toppingGroup.dart';
import 'logout_repository.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

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
  late LogoutRepository _logoutRepository;
  var logoutEmail = "";
  IO.Socket socket =
      IO.io("https://demo-foodinventoryde.herokuapp.com", <String, dynamic>{
    "transports": ["websocket"],
    'autoConnect': false
  });
  bool isSocketOrderAdded = false;
  String email = "";
  OrderListResponseModel model = OrderListResponseModel.fromJson({});
  String resId = '';
  int pendingOrder = 0;

  @override
  void initState() {
    // clearImageCache();
    getLoginData();
    initPreferences();

    _logoutRepository = LogoutRepository(context);

    avatarWidget = Container();
    controller = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.value = 0;
      controller.animateTo(22, duration: const Duration(milliseconds: 1500));
    });
    StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
      print("Inside initLocalStorage " + email);
      this.email = email;
      setState(() {
        logoutEmail = email;
      });
      socket.connect();
      socket.onConnect((_) {
        print("Connected");
        socket.emit("joinOwner", email);
      });

      listenToSocket();
    });
    super.initState();
  }

  listenToSocket() {
    socket.on("onOrderAdded", (response) {
      print("Socket response");
      isSocketOrderAdded = true;
      model = OrderListResponseModel.fromJson(response);
      getPendingOrderValue(true);
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var notiCount;
  initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  clearImageCache(id) async {
    await CachedNetworkImage.evictFromCache(getImageURL(IMAGE_ICON, resId));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getLoginData() async {
    StorageUtil.getData(StorageUtil.keyLoginData, "")!.then((value) {
      print("Storage Data : $value");
      if (value != null && value != "") {
        setState(() {
          LoginData loginData = LoginData.fromJson(jsonDecode(value));
          restaurantName = loginData.restaurantName!;
          restaurantName = defaultValue(loginData.restaurantName, "N/A");
        });
      }
    });
    print("raj" "dfhshdkfjshfhsdjfsjsfdgs");
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const Order();
      case 1:
        return const InstantAction();
      case 2:
        return const OfferDiscount();
      case 3:
        return const Menu();
      case 4:
        return const ItemsTimeSet();
      case 5:
        return const RestaurantTimeSet();
      case 6:
        return const DeliverySetting();
      case 7:
        return const RestaurantDetails();
      case 8:
        return const Settings();
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
    if (!mOriginaListMain.contains(index)) {
      mOriginaListMain.add(index);
      List<String> stringsList =
          mOriginaListMain.map((i) => i.toString()).toList();
      _prefs.setStringList(Constants.backPages, stringsList);
    }
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  getPendingOrderValue(bool isLoad) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        print("restauranttoday");
        print(restaurantId);
        setState(() {
          resId = restaurantId;
          clearImageCache(restaurantId);
        });
        try {
          String params = "";
          if (selectedDate.isNotEmpty) {
            params = "date=$selectedDate";
          }
          String body = "";
          if (params.isNotEmpty) {
            body = "?$params";
          }
          if (!isSocketOrderAdded) {
            final response = await ApiBaseHelper()
                .getwith(ApiBaseHelper.getOrders + body, token, restaurantId);
            model = OrderListResponseModel.fromJson(
                ApiBaseHelper().returnResponse(context, response));
          }
          isSocketOrderAdded = false;
          print("todayresponfirst");
          print("todayresponfirst");
          if (model.success!) {
            print("todayresponse");
            print(model.data.toString());
            if (isLoad) {
              if (model.summaryData != null) {
                var pending = int.parse(defaultValue(
                    model.summaryData?.pendingOrder.toString(), "0"));
                print(pending);
                print(pendingOrder);
                if (pending > 0) {
                  setState(() {
                    pendingOrder = pending;
                  });
                }
              }
            }
          }
        } catch (e) {
          print(e.toString());
        }
      });
    });
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
          builder: (context) => AlertDialog(
            content: const Text('Are you sure you want to exit?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: TextStyle(
                        color: Colors.lightBlue.shade700,
                        fontWeight: FontWeight.bold)),
              ),
              FlatButton(
                onPressed: () async {
                  // Utils.hideLoader(context);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text('Yes',
                    style: TextStyle(
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

    // ignore: unnecessary_null_comparison
    if (arguments != null && _checkPage != -1) {
      SharedPreferences.getInstance().then((value) {
        List<String> mList =
            (value.getStringList(Constants.backPages) ?? <String>[]);

        List<int> mOriginaList = mList.map((i) => int.parse(i)).toList();

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
          child: SizedBox(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              width: 55,
                              height: 60,
                              child: CachedNetworkImage(
                                useOldImageOnUrlChange: false,
                                imageUrl: getImageURL(IMAGE_ICON, resId),
                                imageBuilder: (imageContext, imageProvider) {
                                  return Container(
                                    width: 55,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    SvgPicture.asset(
                                  placeHolder,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              restaurantName,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
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
                  padding: const EdgeInsets.only(top: 05, bottom: 0, right: 10),
                  color: colorButtonBlue,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Center(
                            child: FlatButton(
                              minWidth: 20,
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                icMenuHam,
                              ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Scaffold.of(context).openDrawer();
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  controller.value = 0;
                                  controller.animateTo(22,
                                      duration:
                                          const Duration(milliseconds: 1500));
                                });
                              },
                              shape: const CircleBorder(),
                            ),
                          ),
                          Text(
                            restaurantName,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                                color: colorTextWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ]),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderHistory()));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    getCurrentDateInFormat(),
                                    style: const TextStyle(
                                        color: colorTextWhite,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(width: 15),
                                  SvgPicture.asset(
                                    icCalendar,
                                    height: MediaQuery.of(context).size.height *
                                        0.021,
                                    width: MediaQuery.of(context).size.width *
                                        0.021,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              child: SvgPicture.asset(
                                icDashRate,
                                height:
                                    MediaQuery.of(context).size.height * 0.021,
                                width:
                                    MediaQuery.of(context).size.width * 0.021,
                                color: colorTextWhite,
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, right: 15, bottom: 0),
                        color: colorBackgroundyellow,
                        child: _getDrawerItemWidget(_selectedDrawerIndex))),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          disabledElevation: 0,
          // foregroun ? dColor : colorTextBlack,
          onPressed: () {
            addMoreDialog();
          },
          child: Container(
            width: 60,
            height: 60,
            child: const Icon(
              Icons.add,
              color: colorTextWhite,
              size: 32,
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [colorGreen2, colorGreen1])),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: colorTextWhite,
          elevation: 10,
          shape: const CircularNotchedRectangle(),
          notchMargin: 05,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.075,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(icOrder,
                          height: 20,
                          color: const Color.fromRGBO(124, 117, 175, 1)),
                      const SizedBox(height: 05),
                      const Text(
                        "Orders",
                        style: TextStyle(
                            color: colorTextBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 60),
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(icButton2,
                            height: 20,
                            color: const Color.fromRGBO(124, 117, 175, 1)),
                        const SizedBox(height: 05),
                        const Text(
                          "Table Order",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(icButton3,
                            height: 20,
                            color: const Color.fromRGBO(124, 117, 175, 1)),
                        const SizedBox(height: 05),
                        const Text(
                          "Menu",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(icButton4,
                          height: 20,
                          color: const Color.fromRGBO(124, 117, 175, 1)),
                      const SizedBox(height: 05),
                      const Text(
                        "Reports",
                        style: TextStyle(
                            color: colorTextBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
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

  void addMoreDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 200.0, bottom: 200.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewitem("Add New Item");
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add New Item",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewCategory(TYPE_CATEGORY);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add New Category",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            dialogAddNewOption(TYPE_OPTION);
                          });
                        },
                        child: Card(
                          color: colorButtonBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "Add Option",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: colorButtonBlue,
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewTopping(TYPE_TOPPINGS);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add Toppings",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewToppingGroup(TYPE_GROUP_TOPPINGS);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add Toppings Group",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: colorButtonBlue,
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewAllergy(TYPE_ALLERGY);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add Allergy",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewAllergyGroup(TYPE_ALLERGY_GROUP);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add Allergy Group",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: colorButtonBlue,
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewVarient(TYPE_VERIANT);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add Varient",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                dialogAddNewVarientGroup(TYPE_VARIANT_GROUP);
                              });
                            },
                            child: Card(
                              color: colorButtonBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Add Varient Group",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: colorButtonBlue,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.6),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    icOrderCross,
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                ),
              )
            ],
          ),
        );
      },
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
        margin: const EdgeInsets.only(left: 10, top: 05, bottom: 08, right: 0),
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

  callLogout() async {
    StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
      _logoutRepository.logout(logoutEmail);
      print("Logout initLocalStorage " + logoutEmail);
    });
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
              StorageUtil.clearData().then((value) {
                callLogout();
              });
            },
            child: const Text('Yes', style: TextStyle(color: colorButtonBlue)),
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

  void dialogAddNewitem(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogMenuItems(
          onAddDeleteSuccess: () {
            setState(() {
              _selectedDrawerIndex = 3;
            });
          },
          type: 'Menu',
          isEdit: false,
        );
      },
    );
  }

  void dialogAddNewCategory(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddNewCategory(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewAllergy(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddNewAllergy(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewOption(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddOption(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewTopping(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddToppings(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewToppingGroup(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddToppingGroups(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewAllergyGroup(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddAllergyGroups(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewVarient(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddNewVarient(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewVarientGroup(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddVarientGroups(
          onDialogClose: () {},
        );
      },
    );
  }
}
