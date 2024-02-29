// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:food_inventory/UI/DeliverySettings/delivery_settings.dart';
import 'package:food_inventory/UI/Offer/offer_discount.dart';
import 'package:food_inventory/UI/RestaurantDetails/restaurant_details.dart';

import 'package:food_inventory/UI/instantAction/instant_action.dart';
import 'package:food_inventory/UI/menu/menu.dart';
import 'package:food_inventory/UI/order/order.dart';
import 'package:food_inventory/UI/restaurantTimeSet/restaurantTimeSet.dart';
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
import '../OrderHistory/order_history.dart';
import '../itemsTimeSet/items_time_set.dart';
import '../order/model/order_list_response_model.dart';
import '../reports/reports.dart';
import 'forms/Allergy/add_new_allergy.dart';
import 'forms/AllergyGroup/add_allergy_group.dart';
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
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'model/orderReportModel.dart';
import 'package:volume_controller/volume_controller.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  int _selectedDrawerIndex = 0;

  // final List<int> _backstack = [0];
  List<int> mOriginalListMain = [0];

  late Widget avatarWidget;

  late SharedPreferences _prefs;
  late LogoutRepository _logoutRepository;
  late SharedPreferences prefs;
  var logoutEmail = "";

  //https://foodinventoryukvariant.herokuapp.com/
  //https://demo-foodinventoryde.herokuapp.com

  IO.Socket socket =
  IO.io("https://test-foodinventoryde.herokuapp.com", <String, dynamic>{
  // IO.io("https://orderonline.foodinventory.co.uk", <String, dynamic>{
    "transports": ["websocket"],
    'autoConnect': false
  });

  static const platformChannel = MethodChannel('com.suresh.foodinventory/orderprint');
  bool isSocketOrderAdded = false;
  String email = "";
  OrderListResponseModel model = OrderListResponseModel.fromJson({});
  String resId = '';
  int pendingOrder = 0;

  Widget? selectionWidget;

  String _acceptOrderCount = "",
      _declinedOrderCount = "",
      _orderReceivedCount = "",
      _cash = "",
      _online = "",
      _total = "",
      _historyHeader = "";

  AutoPrintOrderModel autoPrintOrderModel = AutoPrintOrderModel.fromJson({});
  late Timer _timer;
  int mCounter = 1;

  @override
  void initState() {
    // clearImageCache();
    getLoginData();
    initPreferences();

    _logoutRepository = LogoutRepository(context);

    sharedPrefs();
    getProfileData();
    // clearImageCache();

    selectionWidget = Order(
      name: restaurantName,
      onOrderResponse: (String date, SummaryData summaryData) {
        setOrderData(date, summaryData);
      },
    );

    avatarWidget = Container();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
        print("Inside initLocalStorage " + email);
        this.email = email;
        setState(() {
          logoutEmail = email;
        });
        socket.connect();
        socket.onConnect((_) {
          print("Connected D");
          socket.emit("joinOwner", email);
        });

        listenToSocket(token);
      });
    });
    super.initState();
  }

  listenToSocket(token) {
    print("Socket Called D");
    socket.on("onAutoPrintOrder", (response) async {
      print("AutoPrintOrder D" + response.toString());
      if (ApiBaseHelper.autoAccept == true) {
        //order state actions
        print('---Auto Accept Order Response D---');
        orderState.orderId = response;
        await orderState.changeOrderStatus(STATUS_ACCEPTED, orderState.orderId);
        orderState.getOrderListTwo(false);

        if(ApiBaseHelper.autoPrint == true){
          print('---Auto Print Order Response from Dashboard---');
          clearCache();
          await getAutoPrintOrder(token, orderState.orderId);
        }

        playOrderSound ();

      }
    });
    socket.on("onOrderAdded", (response) async {
      print("Socket Response Data Order D " + response.toString());
      if (ApiBaseHelper.autoAccept == false) {

        //order state actions
        print('---Pending Order Response D---');
        orderState.isSocketOrderAdded = true;
        orderState.model = OrderListResponseModel.fromJson(response);
        orderState.getOrderList(false);
        
        if(ApiBaseHelper.autoPrint == true){
          print("Auto printOrder D");
          clearCache();
          await getAutoPrintOrder(token, response);
        }

        playOrderSound ();
      }
    });
  }

  bool orders = true, tableorder = false, menu = false, reports = false;

  // ignore: prefer_typing_uninitialized_variables

  initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  clearImageCache(id) async {
    await CachedNetworkImage.evictFromCache(getImageURL(IMAGE_ICON, resId));
  }

  @override
  void dispose() {
    super.dispose();
    print("Called Dispose");
    socket.emit("leaveOwner", email);
    socket.clearListeners();
    socket.disconnect();
    isSocketOrderAdded = false;
  }

  void setOrderData(String date, SummaryData summaryData) {
    setState(() {
      _acceptOrderCount =
          defaultValue(summaryData.acceptedOrder.toString(), "0");
      _declinedOrderCount =
          defaultValue(summaryData.declinedOrder.toString(), "0");
      _orderReceivedCount =
          defaultValue(summaryData.orderReceived.toString(), "0");
      _cash = getAmountWithCurrency(summaryData.cashOrderAmount.toString());
      print("CaSF:=======================: " +
          summaryData.cashOrderAmount.toString());
      _online = getAmountWithCurrency(summaryData.onlineOrderAmount.toString());
      _total = getAmountWithCurrency(summaryData.totalOrderAmount.toString());
      _historyHeader = date.isEmpty ? "Today" : getOrderStatusDate(date);
      pendingOrder =
          int.parse(defaultValue(summaryData.pendingOrder.toString(), "0"));
      // if (timer != null) {
      //   timer?.cancel();
      // }
      // if (pendingOrder > 0) {
      //   // timer = Timer.periodic(
      //   //     Duration(seconds: 5),
      //   //     (Timer t) => FlutterRingtonePlayer.play(
      //   //           android: AndroidSounds.notification,
      //   //           ios: IosSounds.glass,
      //   //           looping: false,
      //   //           // Android only - API >= 28
      //   //           volume: 1.0,
      //   //           // Android only - API >= 28
      //   //           asAlarm: false, // Android only - all APIs
      //   //         ));
      // } else {
      //   timer?.cancel();
      // }
    });
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
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return selectionWidget = Order(
          name: restaurantName,
          onOrderResponse: (String date, SummaryData summaryData) {
            setOrderData(date, summaryData);
          },
        );
      case 1:
        return selectionWidget = const InstantAction();
      case 2:
        return selectionWidget = const OfferDiscount();
      case 3:
        return selectionWidget = const Menu();
      case 4:
        return selectionWidget = const ItemsTimeSet();
      case 5:
        return selectionWidget = const RestaurantTimeSet();
      case 6:
        return selectionWidget = const DeliverySetting();
      case 7:
        return selectionWidget = RestaurantDetails();
      case 8:
        return selectionWidget = const Settings();
      case 9:
        return selectionWidget = const Reports();
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
    mOriginalListMain = mList.map((i) => int.parse(i)).toList();
    if (!mOriginalListMain.contains(index)) {
      mOriginalListMain.add(index);
      List<String> stringsList =
          mOriginalListMain.map((i) => i.toString()).toList();
      _prefs.setStringList(Constants.backPages, stringsList);
    }
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  getPendingOrderValue(bool isLoad) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        print("restaurantToday");
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
          print("todayResponseFirst");
          if (model.success!) {
            print("todayResponse");
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
    print("_backstack = $mOriginalListMain");
    List<String> mList =
        (_prefs.getStringList(Constants.backPages) ?? <String>[]);
    List<int> mOriginList = mList.map((i) => int.parse(i)).toList();
    if (mOriginList.length > 1) {
      mOriginList.removeAt(mOriginList.length - 1);
      navigateBack(mOriginList[mOriginList.length - 1]);
      List<String> stringsList = mOriginList.map((i) => i.toString()).toList();
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
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: TextStyle(
                        color: Colors.lightBlue.shade700,
                        fontWeight: FontWeight.bold)),
              ),
              TextButton(
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
    //  Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    // ignore: unnecessary_null_comparison
    /*  if (arguments != null && _checkPage != -1) {
      SharedPreferences.getInstance().then((value) {
        List<String> mList =
            (value.getStringList(Constants.backPages) ?? <String>[]);

        List<int> mOriginalList = mList.map((i) => int.parse(i)).toList();

        if (!mOriginalList.contains(arguments['page'])) {
          mOriginalList.add(arguments['page']);
        }

        setState(() {
          _selectedDrawerIndex = arguments['page'];

          _checkPage = -1;
        });

        List<String> stringsList =
            mOriginalList.map((i) => i.toString()).toList();

        value.setStringList(Constants.backPages, stringsList);

        return true;
      });
    }*/

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
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 20,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                child: SvgPicture.asset(
                                  icMenuHam,
                                ),
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(20, 10),
                                    padding: const EdgeInsets.all(10),
                                    shape: const CircleBorder()),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Scaffold.of(context).openDrawer();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {});
                                },
                              ),
                            ),
                          ),
                          Text(
                            restaurantName.length > 15
                                ? '${restaurantName.substring(0, 15)}...'
                                : restaurantName,
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
                                    builder: (context) => OrderHistory(
                                          name: restaurantName,
                                          onOrderResponse: (String date,
                                              SummaryData summaryData) {
                                            setOrderData(date, summaryData);
                                          },
                                        )));
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
                                        0.024,
                                    width: MediaQuery.of(context).size.width *
                                        0.024,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ),
                            /* const SizedBox(width: 10),
                            GestureDetector(
                              child: Container(
                                child: CircleAvatar(
                                  backgroundColor: colorButtonBlue,
                                  radius: 8,
                                  child: SvgPicture.asset(
                                    icDashDoc,
                                    height: 17,
                                    // width: 35.sp,
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 2),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                printDialog();
                              },
                            ),*/
                            const SizedBox(width: 10),
                            GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: colorButtonYellow,
                                radius: MediaQuery.of(context).size.height *
                                    0.017,
                                child: SvgPicture.asset(
                                  icEuroReport,
                                  height: MediaQuery.of(context).size.height *
                                      0.024,
                                  width: MediaQuery.of(context).size.width *
                                      0.024,
                                  color: colorTextWhite,
                                  // width: 35.sp,
                                ),
                              ),
                              /*SvgPicture.asset(
                                icDashRate,
                                height:
                                    MediaQuery.of(context).size.height * 0.024,
                                width:
                                    MediaQuery.of(context).size.width * 0.024,
                                color: colorTextWhite,
                              ),*/
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _statusDialog();
                              },
                            ),
                          ],
                        )
                      ]),
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 0, top: 10, right: 0, bottom: 0),
                        color: colorBackgroundyellow,
                        child: _getDrawerItemWidget(_selectedDrawerIndex))),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          disabledElevation: 0,
          onPressed: () {
            /* addMoreDialog();*/
            setState(() {
              _selectedDrawerIndex = 8;
            });
          },
          child: Container(
            width: 60,
            height: 60,
            child: /*SvgPicture.asset(
              icSetting,
              height: 25,
              width: 25,
              color: colorGreen1,
            ),*/
                const Icon(
              Icons.settings,
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
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDrawerIndex = 0;
                      orders = true;
                      menu = false;
                      tableorder = false;
                      reports = false;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(icOrder,
                          height: 20,
                          color: !orders
                              ? const Color.fromRGBO(124, 117, 175, 1)
                              : colorGreen),
                      const SizedBox(height: 05),
                      Text(
                        "Orders",
                        style: TextStyle(
                            color: !orders ? colorTextBlack : colorGreen,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 60),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // orders = false;
                        // menu = false;
                        // tableorder = false;
                        // reports = false;
                      });
                    },
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
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDrawerIndex = 3;
                        menu = true;
                        orders = false;
                        tableorder = false;
                        reports = false;
                        print(menu);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(icButton3,
                            height: 20,
                            color: !menu
                                ? const Color.fromRGBO(124, 117, 175, 1)
                                : colorGreen),
                        const SizedBox(height: 05),
                        Text(
                          "Menu",
                          style: TextStyle(
                              color: !menu ? colorTextBlack : colorGreen,
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
                          color: !reports
                              ? const Color.fromRGBO(124, 117, 175, 1)
                              : colorGreen),
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
                  onTap: () {
                    setState(() {
                      _selectedDrawerIndex = 9;
                      menu = false;
                      orders = false;
                      tableorder = false;
                      reports = true;
                      //print(menu);
                      //reportsDailog()
                    });
                  },
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

  void _statusDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Container(
            // onWillPop: () async => false,
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 40, right: 25),

            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height * 0.50,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.close, color: Colors.grey),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Container(
                      // decoration : BoxDecoration(color : colorTextWhite),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text(
                          //   _historyHeader + "’s Status",
                          //   style: TextStyle(
                          //       fontSize: 30.sp,
                          //       fontWeight: FontWeight.bold,
                          //       color: colorTextBlack),
                          // ),
                          RichText(
                              text: TextSpan(
                                  text: _historyHeader + "’s Status",
                                  style: const TextStyle(
                                      color: colorTextBlack,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  children: const [])),
                          const SizedBox(height: 10),
                          RichText(
                              text: TextSpan(
                                  text: "Accepted Order :- ",
                                  style: const TextStyle(
                                      color: colorTextBlack, fontSize: 15),
                                  children: [
                                TextSpan(
                                    text: _acceptOrderCount,
                                    style: const TextStyle(
                                        color: colorLightRed, fontSize: 15)),
                              ])),
                          const SizedBox(height: 8),
                          RichText(
                              text: TextSpan(
                                  text: "Declined Order :- ",
                                  style: const TextStyle(
                                      color: colorTextBlack, fontSize: 15),
                                  children: [
                                TextSpan(
                                    text: _declinedOrderCount,
                                    style: const TextStyle(
                                        color: colorLightRed, fontSize: 15)),
                              ])),
                          const SizedBox(height: 8),
                          RichText(
                              text: TextSpan(
                                  text: "Pending Order :- ",
                                  style: const TextStyle(
                                      color: colorTextBlack, fontSize: 15),
                                  children: [
                                TextSpan(
                                    text: _orderReceivedCount == 'null'
                                        ? "0"
                                        : _orderReceivedCount,
                                    style: const TextStyle(
                                        color: colorLightRed, fontSize: 15)),
                              ])),
                          const SizedBox(height: 8),
                          RichText(
                              text: TextSpan(
                                  text: "Cash :- ",
                                  style: const TextStyle(
                                      color: colorTextBlack, fontSize: 15),
                                  children: [
                                TextSpan(
                                    text: _cash,
                                    style: const TextStyle(
                                        color: colorLightRed, fontSize: 15)),
                              ])),
                          const SizedBox(height: 8),
                          RichText(
                              text: TextSpan(
                                  text: "Online :- ",
                                  style: const TextStyle(
                                      color: colorTextBlack, fontSize: 15),
                                  children: [
                                TextSpan(
                                    text: _online,
                                    style: const TextStyle(
                                        color: colorLightRed, fontSize: 15)),
                              ])),
                          const SizedBox(height: 8),
                          RichText(
                              text: TextSpan(
                                  text: "Total :- ",
                                  style: const TextStyle(
                                      color: colorTextBlack, fontSize: 15),
                                  children: [
                                TextSpan(
                                    text: _total,
                                    style: const TextStyle(
                                        color: colorLightRed, fontSize: 15)),
                              ]))
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
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
                  child: SingleChildScrollView(
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
                                  dialogAddNewItem("Add New Item");
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
                                  dialogAddNewVariant(TYPE_VERIANT);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Variant",
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
                                    "Add Variant Group",
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
          mOriginalListMain.clear();
        }
        if (pageIndex != -1) {
          _onSelectItem(pageIndex);
        }
        print("Page Data: " + pageIndex.toString());
        // });
        setState(() {
          menu = false;
          orders = false;
          tableorder = false;
          reports = false;
        });
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

  void dialogAddNewItem(String type) {
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

  void dialogAddNewVariant(String type) {
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

  void printDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Container(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 40, right: 80, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            width: MediaQuery.of(context).size.width * 0.32,
            height: MediaQuery.of(context).size.height * 0.32,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.close, color: Colors.grey),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                // Si zedBox(height: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          getOrderData("X");
                        });
                      },
                      child: Card(
                        color: colorButtonBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                            "Print X Report",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          getOrderData("Y");
                        });
                      },
                      child: Card(
                        color: colorButtonBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                            "Print Y Report",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isDataLoad = false;
  List<ReportData> reportData = [];
  List<ItemData> itemDetails = [];

  getOrderData(type) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response = await ApiBaseHelper()
            .get(ApiBaseHelper.getOrderReport + type, token);
        print("REsponseData " + response.toString());
        print(ApiBaseHelper.getOrderReport + type);
        OrderReport model = OrderReport.fromJson(
            ApiBaseHelper().returnResponse(context, response));

        /*  setState(() {
          isDataLoad = false;
        });*/
        if (model.success!) {
          if (model.reportData!.isNotEmpty) {
            setState(() {
              reportData = model.reportData!;
              for (int i = 0; i < model.reportData!.length; i++) {
                itemDetails = model.reportData![i].itemDetails!;
              }
              print("nonovce API DATA======================================");
              _printOrderReport(
                  reportData, model.reportSummary!, model.restDetails!, type);
            });
          }
        }
      } catch (e) {
        print(e.toString());
        /* setState(() {
          isDataLoad = false;
        });*/
      }
    });
  }

  Future<void> _printOrderReport(List<ReportData> orderDataModel,
      List<ReportSummary> report, RestDetails resDetails, type) async {
    print("sunmiXY======================================");
    // for (int i = 0; i < report.length; i++) {
    // orderReport = report[i].sId;
    // print("================================" + orderReport);
    var jsonData = jsonEncode({
      'reportData': orderDataModel,
      'reportSummary': report,
      'restDetails': resDetails
    });
    SunmiPrinter.text(
      jsonData.toString(),
      styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );
    SunmiPrinter.hr();
    SunmiPrinter.emptyLines(3);
    // }
  }

  // getAutoPrintOrder(token, orderId) async {
  //   final response = await ApiBaseHelper()
  //       .get(ApiBaseHelper.getOrderPerUser + "/" + orderId, token);
  //   print("AutoAcceptOrder Res " + response.toString());
  //   autoPrintOrderModel = AutoPrintOrderModel.fromJson(
  //       ApiBaseHelper().returnResponse(context, response));
  //
  //   if (ApiBaseHelper.autoPrint == true) {
  //     Future.delayed(const Duration(milliseconds: 1000), () {
  //       print("AutoPrint Working");
  //       _printOrder(autoPrintOrderModel.data!);
  //       _timer = Timer.periodic(
  //           const Duration(seconds: 3), (timer) {
  //         print("CounterCount " +
  //             mCounter.toString());
  //         if (ApiBaseHelper.printCount >
  //             mCounter) {
  //           if (mounted) {
  //             setState(() {
  //               print("Print Count time D $mCounter");
  //               _printOrder(autoPrintOrderModel.data!);
  //               mCounter++;
  //             });
  //           }
  //         } else {
  //           _timer.cancel();
  //         }
  //       });
  //     });
  //   }
  //   if (ApiBaseHelper.autoAccept == true) {
  //     print("Auto Accept Working");
  //     // await changeOrderStatus(STATUS_ACCEPTED, orderId);
  //   }
  // }

  getAutoPrintOrder(token, orderId) async {

    Future.delayed(const Duration(milliseconds: 3000), () {

      int mCounter = 0;
      _timer = Timer.periodic(
          const Duration(seconds: 3), (timer) async {

        if (ApiBaseHelper.printCount > mCounter) {
          if (mounted) {

            await _printOrder(orderList[0]);
            mCounter++;
          }
        } else {
          _timer.cancel();
        }
      });
    });

  }

  Future<void> _printOrder(OrderDataModel orderDataModel) async {
    StorageUtil.getData(StorageUtil.keyLoginData, "")!.then((value) async {
      print("Storage Data : $value");
      if (value != null && value != "") {
        LoginData loginData = LoginData.fromJson(jsonDecode(value));

        if (checkString(loginData.wifiPrinterIP) ||
            checkString(loginData.wifiPrinterPort)) {
          showMessage(
              "Add WIFI Printer IP Address and Port number from Setting.",
              context);
        } else {
          try {
            var name = jsonEncode(orderDataModel);
            print("OrderDetail  $name");

            if (ApiBaseHelper.print50mm == true) {
              // Test regular text
              /*     SunmiPrinter.hr();
            SunmiPrinter.text(
              'Test Sunmi Printer',
              styles: SunmiStyles(align: SunmiAlign.center),
            );
            SunmiPrinter.hr();*/

              // Test align
              /*SunmiPrinter.text(
              'left',
              styles: SunmiStyles(bold: true, underline: true),
            );
            SunmiPrinter.text(
              'center',
              styles:
              SunmiStyles(bold: true, underline: true, align: SunmiAlign.center),
            );*/

              SunmiPrinter.text(
                orderDataModel.orderDateTime,
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.right),
              );

              // ByteData bytes = await rootBundle.load('assets/logo.jpg');
              // final buffer = bytes.buffer;
              // final imgData = base64.encode(Uint8List.view(buffer));
              // SunmiPrinter.image(
              //     imgData,
              //     align: SunmiAlign.center,
              // );
              //
              // SunmiPrinter.hr();

              SunmiPrinter.text(
                loginData.restaurantName,
                styles: const SunmiStyles(
                    bold: true,
                    underline: false,
                    align: SunmiAlign.center,
                    size: SunmiSize.md),
              );

              SunmiPrinter.text(
                loginData.location,
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                "Tel.: " + loginData.phoneNumber.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                "Bestellnummer : " +
                    orderDataModel.orderNumber.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                orderDataModel.deliveryType.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                "Bestatigte Ziet : " + orderDataModel.orderTime!,
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              /*  SunmiPrinter.row(cols: [
                SunmiCol(text: 'Auftragsart', width: 5, align: SunmiAlign.left),
                SunmiCol(text: '', width: 2, align: SunmiAlign.center),
                SunmiCol(
                    text: widget.orderDataModel.deliveryType,
                    width: 5,
                    align: SunmiAlign.right),
              ], bold: true);*/

              /*SunmiPrinter.row(cols: [
                SunmiCol(text: 'Lieferzeit ', width: 5, align: SunmiAlign.left),
                SunmiCol(text: '', width: 2, align: SunmiAlign.center),
                SunmiCol(
                    text: widget.orderDataModel.orderTime,
                    width: 5,
                    align: SunmiAlign.right),
              ], bold: true);*/

              /* SunmiPrinter.row(cols: [
                SunmiCol(
                    text: 'Zahlungsmethode', width: 5, align: SunmiAlign.left),
                SunmiCol(text: '', width: 2, align: SunmiAlign.center),
                SunmiCol(
                    text: widget.orderDataModel.paymentMode,
                    width: 5,
                    align: SunmiAlign.right),
              ], bold: true);*/

              SunmiPrinter.hr();
              SunmiPrinter.text(
                orderDataModel.userDetails!.firstName.toString() +
                    " " +
                    orderDataModel.userDetails!.lastName.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.left),
              );

              SunmiPrinter.text(
                orderDataModel.userDetails!.contact.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.left),
              );

              if (orderDataModel.deliveryType != "PICKUP") {
                SunmiPrinter.text(
                  orderDataModel.userDetails!.address.toString(),
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.left),
                );
              }

              if (orderDataModel.deliveryType != "PICKUP") {
                SunmiPrinter.text(
                  orderDataModel.userDetails!.postcode.toString(),
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.left),
                );
              }

              SunmiPrinter.hr();

              String quantity = "";
              int sum = 0;
              int sumParse = 0;
              int discount = 0;
              for (var i = 0;
              i < orderDataModel.itemDetails!.length;
              i++) {
                ItemDetails itemData = orderDataModel.itemDetails![i];
                discount = itemData.discount!;
                quantity = itemData.quantity!.toString();
                sumParse = int.parse(quantity);
                sum = sum + sumParse;
                print(" QuantityTotal $quantity ");
                print(" QuantitySum $sum ");
                if (discount != 0) {
                  SunmiPrinter.text(
                    itemData.discount.toString() + "% OFF",
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                } else if (itemData.catDiscount != 0) {
                  SunmiPrinter.text(
                    itemData.catDiscount.toString() + "% OFF",
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                } else if (itemData.overallDiscount != 0) {
                  SunmiPrinter.text(
                    itemData.overallDiscount.toString() + "% OFF",
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                }

                SunmiPrinter.row(cols: [
                  SunmiCol(
                      text: itemData.quantity.toString() +
                          "x " +
                          itemData.name.toString(),
                      width: 8,
                      align: SunmiAlign.left),
                  SunmiCol(text: ' ', width: 1, align: SunmiAlign.center),
                  SunmiCol(
                      text: /*itemData.price*/ getAmountWithCurrency(
                          itemData.price.toString()),
                      width: 3,
                      align: SunmiAlign.right),
                ], bold: true);

                if (itemData.option.toString().isNotEmpty) {
                  SunmiPrinter.text(
                    itemData.option.toString(),
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                }

                if (itemData.toppings!.isNotEmpty) {
                  for (int topping = 0;
                  topping < itemData.toppings!.length;
                  topping++) {
                    Toppings top = itemData.toppings![topping];
                    SunmiPrinter.text(
                      "+ " +
                          top.toppingCount.toString() +
                          " " +
                          top.name.toString() +
                          " " +
                          " (" +
                          top.price.toString() +
                          ")",
                      styles: const SunmiStyles(
                          bold: true, underline: false, align: SunmiAlign.left),
                    );
                  }
                }
                SunmiPrinter.text(
                  itemData.note.toString(),
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.left),
                );
                /*  SunmiPrinter.text(
                  "${defaultValue(itemData.quantity.toString(), "1")} X ${getOptionName(itemData.toppings!, itemData) == "" ? getAmountWithCurrency(itemData.price.toString()) : getAmountWithCurrency(getOptionName(itemData.toppings!, itemData).toString())}",
                  styles: SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.right),
                );
                SunmiPrinter.hr();*/
              }
              SunmiPrinter.hr();

              if (orderDataModel.deliveryCharge != '0') {
                SunmiPrinter.row(cols: [
                  SunmiCol(
                      text: 'Liefergebuehr : ',
                      width: 8,
                      align: SunmiAlign.left),
                  SunmiCol(text: '', width: 1, align: SunmiAlign.center),
                  SunmiCol(
                      text: orderDataModel.deliveryCharge,
                      width: 3,
                      align: SunmiAlign.right),
                ], bold: true);
              }

              /*SunmiPrinter.row(cols: [
                SunmiCol(text: 'Rabatt : ', width: 7, align: SunmiAlign.left),
                SunmiCol(text: '', width: 2, align: SunmiAlign.center),
                SunmiCol(
                    text: widget.orderDataModel.discount,
                    width: 4,
                    align: SunmiAlign.right),
              ], bold: true);*/

              /*SunmiPrinter.row(
              cols: [
                SunmiCol(
                    text: 'Tip : ',
                    width: 5,
                    align: SunmiAlign.left),
                SunmiCol(text: '', width: 3, align: SunmiAlign.center),
                SunmiCol(
                    text: widget.orderDataModel.tip,
                    width: 4,
                    align: SunmiAlign.right),
              ],
            );*/

              SunmiPrinter.hr();

              SunmiPrinter.row(cols: [
                SunmiCol(text: 'Rabatt : ', width: 4, align: SunmiAlign.left),
                SunmiCol(text: '', width: 4, align: SunmiAlign.center),
                SunmiCol(
                    text: getAmountWithCurrency(defaultValue(
                        orderDataModel.discount.toString(), "0")),
                    width: 4,
                    align: SunmiAlign.right),
              ], bold: true);

              SunmiPrinter.hr();

              SunmiPrinter.row(cols: [
                SunmiCol(text: 'Gesamt : ', width: 4, align: SunmiAlign.left),
                SunmiCol(text: '', width: 4, align: SunmiAlign.center),
                SunmiCol(
                    text: orderDataModel.totalAmount,
                    width: 4,
                    align: SunmiAlign.right),
              ], bold: true);

              SunmiPrinter.hr();

              orderDataModel.note != null && orderDataModel.note != '' && orderDataModel.note != ' '
                  ?
              SunmiPrinter.text(
                "Notiz : " + orderDataModel.note.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              )
                  : SunmiPrinter()
              ;

              SunmiPrinter.text(
                "Zahlungsmethode : " +
                    orderDataModel.paymentMode.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );
              if (orderDataModel.paymentMode == "Online") {
                SunmiPrinter.text(
                  "Bestellung wurde online bezahlt",
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.center),
                );
              }

              SunmiPrinter.hr();

              /*   // Test text size
            SunmiPrinter.text('Extra small text',
                styles: SunmiStyles(size: SunmiSize.xs));
            SunmiPrinter.text('Medium text', styles: SunmiStyles(size: SunmiSize.md));
            SunmiPrinter.text('Large text', styles: SunmiStyles(size: SunmiSize.lg));
            SunmiPrinter.text('Extra large text',
                styles: SunmiStyles(size: SunmiSize.xl));

            // Test row
            SunmiPrinter.row(
              cols: [
                SunmiCol(text: 'col1', width: 4),
                SunmiCol(text: 'col2', width: 4, align: SunmiAlign.center),
                SunmiCol(text: 'col3', width: 4, align: SunmiAlign.right),
              ],
            );*/

              // Test image
              var response = await http.get(Uri.parse('https://api.qrcode-monkey.com/qr/custom?data=${ApiBaseHelper.websiteURL}'));
              if (response.statusCode == 200) {
                // Display the QR code image in your app

                final buffer = response.bodyBytes.buffer;
                final imgData = base64.encode(Uint8List.view(buffer));
                SunmiPrinter.image(imgData);
              }
              // ByteData bytes = await rootBundle.load('assets/qr_bill.png');
              // final buffer = bytes.buffer;
              // final imgData = base64.encode(Uint8List.view(buffer));
              // SunmiPrinter.image(imgData);

              SunmiPrinter.emptyLines(3);
            } else {
              platformChannel.invokeMethod('print_order', {
                'name': defaultValue(loginData.restaurantName, ""),
                'phone': defaultValue(loginData.phoneNumber, ""),
                'address': defaultValue(loginData.location, ""),
                'quantity':
                orderDataModel.itemDetails!.length.toString(),
                'orderData': jsonEncode(orderDataModel),
                'ip_address': defaultValue(loginData.wifiPrinterIP, ""),
                'port_number': defaultValue(loginData.wifiPrinterPort, "")
              });
            }
          } on PlatformException {
            print("PlatformException");
          }
        }
      }
    });
  }

  String getOptionName(List<Toppings> list, ItemDetails items) {
    String optionName = "";
    String priceData = "";
    if (list.isEmpty) {
      optionName = "";
    } else {
      for (Toppings data in list) {
        if (optionName.isEmpty) {
          optionName = "${data.toppingCount! * double.parse(data.price!)}";
          var vPrice = '0';
          var vsPrice = '0';
          items.variantPrice != '0' ? vPrice = items.variantPrice! : vPrice;
          items.subVariantPrice != 0 ? vsPrice = items.variantPrice! : vsPrice;
          priceData =
              "${double.parse(optionName) + double.parse(vPrice) + double.parse(vsPrice) + double.parse(items.price!)}";
        } else {
          var dat = "${data.toppingCount! * double.parse(data.price!)}";
          optionName = "${double.parse(optionName) + double.parse(dat)}";
          var vPrice = '0';
          var vsPrice = '0';
          items.variantPrice != '0' ? vPrice = items.variantPrice! : vPrice;
          items.subVariantPrice != 0 ? vsPrice = items.variantPrice! : vsPrice;
          priceData =
              "${double.parse(optionName) + double.parse(vPrice) + double.parse(vsPrice) + double.parse(items.price!)}";
        }
      }
    }

    return priceData;
  }

  sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  getProfileData() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((id) async {
        setState(() {
          isDataLoad = true;
          resId = id;
          print("ResId= " + resId);
        });
        try {
          final response = await ApiBaseHelper()
              .get(ApiBaseHelper.profile + "/" + id, value);
          var model = LoginModel.fromJson(
              ApiBaseHelper().returnResponse(context, response));
          setState(() {
            isDataLoad = false;
          });
          if (model.success!) {
            StorageUtil.setData(
                StorageUtil.keyLoginData, json.encode(model.data));
            setState(() {
              ApiBaseHelper.websiteURL = model.data!.websiteURL!;
              ApiBaseHelper.autoAccept = model.data!.autoAccept!;
              ApiBaseHelper.autoPrint = model.data!.autoPrint!;
            });
          }
        } catch (e) {
          print(e.toString());
          setState(() {
            isDataLoad = false;
          });
        }
      });
    });
  }

  void clearCache() {
    DefaultCacheManager().emptyCache();
  }

  Future<void> playOrderSound () async {
    VolumeController().maxVolume(showSystemUI: false);
    final player = AudioPlayer();
    await player.play(AssetSource('tone.mp3'),volume: 1.0);
  }
}
