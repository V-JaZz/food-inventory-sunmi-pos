import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant/colors.dart';
import '../../constant/image.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController _userNameController;

  late TextEditingController _oldPassController;

  late TextEditingController _newPassController;
  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _oldPassController =  TextEditingController();
    _newPassController =  TextEditingController();
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
                  // fit: StackFit.loose,
                  children: [
                    SvgPicture.asset(
                      icLogin,
                      height: MediaQuery.of(context).size.height * 0.095,
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 05),
                      child: const Text(
                        "Reset Your Password",
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
                    borderRadius: const BorderRadius.all( Radius.circular(100)),
                  ),
                  child: TextField(
                    controller: _userNameController,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: colorButtonBlue),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SvgPicture.asset(
                          icUser,
                          color: colorButtonBlue,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints.expand(height: 20, width: 40),
                      hintText: "User Name...",
                      hintStyle: const TextStyle(
                        color: colorButtonBlue,
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
                    borderRadius: const BorderRadius.all( Radius.circular(100)),
                  ),
                  child: TextField(
                    controller: _oldPassController,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: colorButtonBlue),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SvgPicture.asset(
                          icLock,
                          color: colorButtonBlue,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints.expand(height: 20, width: 40),
                      hintText: "Old Password...",
                      hintStyle: const TextStyle(
                        color: colorButtonBlue,
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
                    controller: _newPassController,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: colorButtonBlue),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        isDense: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SvgPicture.asset(
                            icLock,
                            color: colorButtonBlue,
                          ),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints.expand(height: 20, width: 40),
                        hintText: "New Password...",
                        hintStyle: const TextStyle(
                          color: colorButtonBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none),
                    obscureText: true,
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 45),
                    decoration: const BoxDecoration(
                      color: colorButtonYellow,
                      borderRadius: BorderRadius.all( Radius.circular(100)),
                    ),
                    // margin: EdgeInsets.only(top: 45),
                    child: const Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: colorTextWhite,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
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
}
