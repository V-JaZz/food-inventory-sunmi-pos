import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/instantAction/insrance_action_repository.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../../constant/colors.dart';

class InstantAction extends StatefulWidget {
  const InstantAction({Key? key}) : super(key: key);

  @override
  State<InstantAction> createState() => _InstantActionState();
}

class _InstantActionState extends State<InstantAction> {
  late InstanceActionRepository _repository;

  bool isOpen = true, isClose = false;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _repository = InstanceActionRepository(context);
    getProfileData();
  }

  getProfileData() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((id) async {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        try {
          final response = await ApiBaseHelper()
              .get(ApiBaseHelper.profile + "/" + id, value);
          LoginModel model = LoginModel.fromJson(
              ApiBaseHelper().returnResponse(context, response));
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            StorageUtil.setData(
                StorageUtil.keyLoginData, json.encode(model.data));

            setState(() {
              if (model.data!.isOnline!) {
                isOpen = true;
                isClose = false;
              } else {
                isOpen = false;
                isClose = true;
              }
            });
          }
        } catch (e) {
         
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      });
    });
  }

  callApi(String value) async {
    _repository.changeAction(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Select Instant Action",
          style: TextStyle(
            color: colorTextBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: 57,
          width: 280,
          margin: const EdgeInsets.only(top: 20, right: 50),
          decoration: BoxDecoration(
              color: colorTextWhite,
              borderRadius: BorderRadius.circular(46),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0), //(x,y)
                  blurRadius: 1.0,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isOpen ? colorGreen : colorTextWhite,
                      borderRadius: BorderRadius.circular(46)),
                  child: Text(
                    "Open",
                    style: TextStyle(
                      color: isOpen ? colorTextWhite : colorGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  if (!isOpen) {
                    setState(() {
                      isOpen = true;
                      isClose = false;
                    });

                    callApi("1");
                  }
                },
                behavior: HitTestBehavior.opaque,
              )),
              Expanded(
                  child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isClose ? colorButtonYellow : colorTextWhite,
                      borderRadius: BorderRadius.circular(46)),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: isClose ? colorTextWhite : colorButtonYellow,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  if (!isClose) {
                    setState(() {
                      isOpen = false;
                      isClose = true;
                    });
                    callApi("0");
                  }
                },
                behavior: HitTestBehavior.opaque,
              )),
            ],
          ),
        )
      ],
    );
  }
}
