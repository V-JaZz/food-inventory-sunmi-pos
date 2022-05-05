import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static GifController? controller;

  static void showToast(String text, Color bgColor) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        // backgroundColor: bgColor,
        backgroundColor: Colors.grey.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static bool isValidEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

  // static void showSnackbar(BuildContext context, String text, Color bgColor) {
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text(text),
  //     backgroundColor: bgColor,
  //     duration: Duration(seconds: 3),
  //   ));
  // }

  static void showLoaderDialog(
      BuildContext context, TickerProvider tickerProvider) {
    // GifController controller;
    // controller = GifController(vsync: tickerProvider);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.repeat(
    //       min: 0.0, max: 109.0, period: Duration(milliseconds: 2500));
    // });

    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // content: GifImage(
        //   width: 70,
        //   height: 70,
        //   controller: controller,
        //   repeat: ImageRepeat.noRepeat,
        //   image: AssetImage("assets/images/loader.gif"),
        // ));
        // content: ShowCase());
        content: CircularProgressIndicator(color: Colors.blue));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: alert);
      },
    );
  }

  static void hideLoader(BuildContext context) {
    // if (controller != null) {
    //   controller.dispose();
    // }

    Navigator.pop(context);

    // controller = null;
  }

  static Widget textView(
      String text, double fontSize, Color textColor, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
          color: textColor, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  static String truncateString(String data, int length) {
    return (data.length >= length) ? '${data.substring(0, length)}...' : data;
  }

  static Widget textViewAlign(String text, double fontSize, Color textColor,
      FontWeight fontWeight, TextAlign textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      style: TextStyle(
          color: textColor, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  // static Future<String> getDeviceId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }

  static String capitalizeFirstLetter(String word) {
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }
}
