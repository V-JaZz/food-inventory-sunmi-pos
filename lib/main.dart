import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_inventory/UI/Dashboard/dashboard.dart';
import 'package:food_inventory/UI/Login/login.dart';
import 'constant/colors.dart';
import 'constant/image.dart';
import 'constant/storage_util.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print(message.data);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(255, 255, 255, .1),
      100: Color.fromRGBO(255, 255, 255, .2),
      200: Color.fromRGBO(255, 255, 255, .3),
      300: Color.fromRGBO(255, 255, 255, .4),
      400: Color.fromRGBO(255, 255, 255, .5),
      500: Color.fromRGBO(255, 255, 255, .6),
      600: Color.fromRGBO(255, 255, 255, .7),
      700: Color.fromRGBO(255, 255, 255, .8),
      800: Color.fromRGBO(255, 255, 255, .9),
      900: Color.fromRGBO(255, 255, 255, 1),
    };

    MaterialColor colorCustom = MaterialColor(0xFF51C800, color);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: colorCustom,
          fontFamily: 'Roboto',
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String tokent = "";
  String token = "";
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    setState(() {
      token = token;
    });
    print("Firebase FCM: " + token);
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) {
      tokent = value;
    });
    startTime();
    getToken();
    firebase();
    checkForInitialMessage();
  }

  firebase() async {
    await Firebase.initializeApp();
    print("FIREBASE=========================================");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    AndroidInitializationSettings initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings initializationSettingsIOS =
        new IOSInitializationSettings(requestBadgePermission: true);
    InitializationSettings initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
              ),
            ));
        print("Data Notification firebase==================");
        // FlutterRingtonePlayer.play(
        //   android: AndroidSounds.notification,
        //   ios: IosSounds.glass,
        //   looping: true, // Android only - API >= 28
        //   volume: 0.5, // Android only - API >= 28
        //   asAlarm: false, // Android only - all APIs
        // );

      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (mounted) {
        setState(() {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DashBoard()));
        });
      }
      print('Message clicked!');
    });
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      RemoteNotification? notification = initialMessage.notification;
      AndroidNotification? android = initialMessage.notification?.android;
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: android?.smallIcon,
            ),
          ));
      setState(() {});
    }
  }

  startTime() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, route);
  }

  route() {
    print(tokent + ":::TOKEN IS HERE");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                tokent.isEmpty ? const LoginPage() : DashBoard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: [
          Align(
            child: Image.asset(topLeftImage),
            alignment: Alignment.topLeft,
          ),
          Align(
            child: Image.asset(bottomRightImage),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
      decoration: BoxDecoration(color: colorBackground),
    ));
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        color: colorGreen,
                      ),
                    )
                  ]));
        });
  }
}
