import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/Dashboard/dashboard.dart';
import 'package:food_inventory/UI/ResetPass/reset_password.dart';
import '../../constant/colors.dart';
import '../../constant/image.dart';
import 'login_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late String devicetoken;
  late LoginRepository _loginRepository;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  late TextEditingController _passController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _loginRepository = LoginRepository(context);
    getToken();
  }

  callLogin() async {
    _loginRepository.login(
        _emailController.text, _passController.text, devicetoken);
    print(_emailController.text);
    print(_passController.text);
    print(devicetoken);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Align(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SvgPicture.asset(
                      icLogin,
                      height: MediaQuery.of(context).size.height * 0.13,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 05),
                      child: const Text(
                        "Login!",
                        style: TextStyle(
                            color: colorTextBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 45),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: colorBorderBlack.withOpacity(0.30),
                        blurRadius: 10.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                  child: TextField(
                    controller: _emailController,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: colorTextBlack),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SvgPicture.asset(
                          icUser,
                          color: colorTextBlack,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints.expand(height: 20, width: 40),
                      hintText: "User Name...",
                      hintStyle: const TextStyle(
                        color: colorTextBlack,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: colorBorderBlack.withOpacity(0.30),
                        blurRadius: 10.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                  child: TextField(
                    controller: _passController,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: colorTextBlack),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        isDense: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SvgPicture.asset(
                            icLock,
                            color: colorTextBlack,
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints.expand(height: 20, width: 40),
                        hintText: "Password...",
                        hintStyle: const TextStyle(
                          color: colorTextBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none),
                    obscureText: true,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(top: 24, left: 0),
                    child: const Text(
                      "Reset Your Password",
                      style: TextStyle(
                          fontSize: 16,
                          color: colorTextBlack,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPassword(),
                        ));
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 45),
                    decoration: const BoxDecoration(
                      color: colorButtonYellow,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: colorTextWhite,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    callLogin();
                  },
                  behavior: HitTestBehavior.opaque,
                ),
              ],
            )
          ],
        ),
        alignment: Alignment.center,
      ),
      decoration: BoxDecoration(color: Colors.amber.shade50),
    ));
  }

  getToken() async {
    devicetoken = (await FirebaseMessaging.instance.getToken())!;
    setState(() {
      devicetoken = devicetoken;
    });
    print("raj" + "dfhshdkfjshfhsdjfsjsfdgs");
    print("dev" + devicetoken);
  }
}
