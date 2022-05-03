import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/colors.dart';
import '../../constant/const.dart';
import '../../constant/utils.dart';
import '../Dashboard/dashboard.dart';
import '../Login/login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  int _selectedDrawerIndex = 0, _checkPage = 0;
  // final List<int> _backstack = [0];
  List<int> mOriginaListMain = [0];

  late GifController controller;

  late Widget avatarWidget;

  late SharedPreferences _prefs;
  var _items = ["Orders", "Instant Action"];
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
      controller.animateTo(22, duration: Duration(milliseconds: 1500));
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
        // changeviewWidget = scheduleblocking(0);
        return new DashBoard();
      case 1:
        // changeviewWidget = container();
        return new LoginPage();
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
                style: TextStyle(fontWeight: FontWeight.bold)),
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
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 3.0,
                    sigmaY: 3.0,
                  ),
                  child: Container(
                    child: Drawer(
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Divider(color: Colors.black)),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    drawerItem(
                                      "Order",
                                      'home.svg',
                                      0,
                                    ),
                                    drawerItem(
                                      'Instant Action',
                                      'book_add.svg',
                                      1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // width: MediaQuery.of(context).size.width * 0.45,
                              // color: Colors.red,
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.only(bottom: 30, top: 5),
                              child: RaisedButton(
                                  elevation: 5,
                                  highlightElevation: 0,
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    // side: BorderSide(color: Colors.grey)
                                  ),
                                  onPressed: () {
                                    Utils.hideLoader(context);
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => new AlertDialog(
                                    //     // title: new Text('Are you sure?'),
                                    //     content: new Text(
                                    //         'Are you sure you want to logout?',
                                    //         textAlign: TextAlign.center,
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.bold)),
                                    //     actions: <Widget>[
                                    //       new FlatButton(
                                    //         onPressed: () =>
                                    //             Navigator.of(context)
                                    //                 .pop(false),
                                    //         child: new Text('No',
                                    //             style: TextStyle(
                                    //                 color: Colors
                                    //                     .lightBlue.shade700,
                                    //                 fontWeight:
                                    //                     FontWeight.bold)),
                                    //       ),
                                    //       new FlatButton(
                                    //         onPressed: () async {
                                    //           Navigator.of(context)
                                    //               .pushAndRemoveUntil(
                                    //                   CupertinoPageRoute(
                                    //                       builder: (context) =>
                                    //                           LoginPage()),
                                    //                   (route) => false);
                                    //         },
                                    //         child: new Text('Yes',
                                    //             style: TextStyle(
                                    //                 color: Colors.red,
                                    //                 fontWeight:
                                    //                     FontWeight.bold)),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // );
                                    showDialog(
                                      context: context,
                                      builder: (context) => new AlertDialog(
                                        // title: new Text('Are you sure?'),
                                        content: new Text(
                                            'Are you sure you want to logout?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        actions: <Widget>[
                                          new FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: new Text('No',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          new FlatButton(
                                            onPressed: () async {
                                              Utils.hideLoader(context);
                                            },
                                            child: new Text('Yes',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Logout",
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        body: Builder(
          builder: (BuildContext context) => SafeArea(
            maintainBottomViewPadding: true,
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, top: 05, bottom: 05, right: 10),
                  // color: CustomColors.headerColor,
                  child: Row(children: [
                    Center(
                      child: Container(
                        child: FlatButton(
                          minWidth: 20,
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/menu.svg',
                            semanticsLabel: 'one',
                            height: 30,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            Scaffold.of(context).openDrawer();
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              // controller.repeat(min: 0, max: 22, period: Duration(milliseconds: 1500));
                              controller.value = 0;
                              controller.animateTo(22,
                                  duration: Duration(milliseconds: 1500));
                            });
                          },
                          shape: CircleBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        // color:Colors.yellow,
                        // width: MediaQuery.of(context).size.width / 1.8,
                        child: Text('${_items[_selectedDrawerIndex]}',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                                color: colorTextBlack,
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
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

  // Widget container() {
  //   return SizedBox();
  // }

  Widget avatar() {
    return InkWell(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => Scheduleblocking()),
      //   );
      // },
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
                backgroundImage: AssetImage('assets/patient.png')),
          ),
        ),
      ),
    );
  }

  Widget drawerItem(String title, String assetName, int pageIndex) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        onPressed: () {
          if (pageIndex == 0) {
            // _backstack.clear();
            mOriginaListMain.clear();
          }

          if (pageIndex != -1) {
            _onSelectItem(pageIndex);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/' + assetName,
                      alignment: Alignment.center,
                      semanticsLabel: assetName,
                      height: 20,
                      width: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 9,
              child: Container(
                // margin: EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      // strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
