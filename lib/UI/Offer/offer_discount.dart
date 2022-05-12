// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/Offer/exclude_page.dart';
import 'package:food_inventory/UI/Offer/offer_repository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../../constant/image.dart';
import '../../constant/validation_util.dart';

class OfferDiscount extends StatefulWidget {
  const OfferDiscount({Key? key}) : super(key: key);

  @override
  State<OfferDiscount> createState() => _OfferDiscountState();
}

class _OfferDiscountState extends State<OfferDiscount> {
  late OfferRepository _offerRepository;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late TextEditingController _offerController;
  late TextEditingController _collectionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offerRepository = OfferRepository(context);
    getProfileData();
    _offerController = TextEditingController(text: "");
    _collectionController = TextEditingController(text: "");
  }

  getProfileData() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((id) async {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        try {
          final response = await ApiBaseHelper()
              .get(ApiBaseHelper.profile + "/" + id, value);
          var model = LoginModel.fromJson(
              ApiBaseHelper().returnResponse(context, response));
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            StorageUtil.setData(
                StorageUtil.keyLoginData, json.encode(model.data));

            setState(() {
              _offerController = TextEditingController(
                  text: defaultValue(
                      model.data!.deliveryDiscount.toString(), ""));
              _collectionController = TextEditingController(
                  text: defaultValue(
                      model.data!.collectionDiscount.toString(), ""));
            });
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      });
    });
  }

  callAddOfferApi() async {
    _offerRepository.addOffer(_offerController, _collectionController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: colorBackgroundyellow,
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Delivery Discount",
            style: const TextStyle(
              color: colorButtonBlue,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.056,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: colorTextWhite,
                  // border: Border.all(color: colorButtonYellow, width: 1),
                  borderRadius: const BorderRadius.all(const Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: colorButtonYellow,
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: SvgPicture.asset(
                        icPercentage,
                        color: Colors.white,
                        width: 12,
                        height: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 18),
                          child: TextField(
                            maxLines: 1,
                            controller: _offerController,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: colorButtonBlue,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: const Text(
                          "Exclude",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                      onTap: () {
                        dialogAddNewType("");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Text(
            "Add Collection Discount",
            style: TextStyle(
                color: colorTextBlack,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.056,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: colorTextWhite,
                  // border: Border.all(color: colorButtonYellow, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: colorButtonYellow,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: const Radius.circular(10)),
                      ),
                      child: SvgPicture.asset(
                        icPercentage,
                        color: Colors.white,
                        width: 12,
                        height: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 18),
                          child: TextField(
                            maxLines: 1,
                            controller: _collectionController,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        // height: MediaQuery.of(context).size.height * 0.0,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(left: 20),
                        decoration: const BoxDecoration(
                          color: colorButtonBlue,
                          borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: const Text(
                          "Exclude",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                      onTap: () {
                        dialogAddNewType("");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 480,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 15, left: 25),
                      decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        "Add",
                        style: const TextStyle(
                            color: colorTextWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      if (_offerController.text.isEmpty) {
                        showMessage("Enter Offer/Discount Value", context);
                      } else {
                        FocusScope.of(context).requestFocus(FocusNode());
                        callAddOfferApi();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 25, left: 15),
                      decoration: BoxDecoration(
                          color: colorGrey,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _offerController = TextEditingController();
                        _collectionController = TextEditingController();
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void dialogAddNewType(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) {
        return ExcluedPage(
          type: type,
          onDialogClose: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
