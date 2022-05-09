import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/settings/restaurant_details_repository.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:image_picker/image_picker.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController wifiController = new TextEditingController(text: "");
  TextEditingController wifiPortController =
      new TextEditingController(text: "");
  TextEditingController deliveryController =
      new TextEditingController(text: "");
  TextEditingController minimumController = new TextEditingController(text: "");
  TextEditingController webSiteUrl = new TextEditingController(text: "");

  // PickedFile? selectedBanner;
  late SharedPreferences prefs;
  bool isDataLoad = false;
  File? cropperFile;
  Future<void> _cropImage(path) async {
    ImageCropper imageCropper = ImageCropper();
    File? croppedfile = await imageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: colorButtonYellow,
            toolbarWidgetColor: colorButtonBlue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedfile != null) {
      cropperFile = croppedfile;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }
  }

  late RestaurantDetailsRepository _restaurantDetailsRepository;
  String resId = "";
  @override
  void initState() {
    super.initState();
    // getLocalIP();
    sharedPrefs();
    // if (ApiBaseHelper.autoAccept!) {
    //   isOpenA = true;
    //   isCloseA = false;
    //   print("ONLINE DELIVERY");
    // } else {
    //   isOpenA = false;
    //   isCloseA = true;
    //   print("ONLINE mkckDELIVERY");
    // }
    // if (ApiBaseHelper.autoPrint!) {
    //   isOpenP = true;
    //   print("ONLINE PICKUP jnj");

    //   isCloseP = false;
    // } else {
    //   isOpenP = false;
    //   print("ONLINE PICKUP");

    //   isCloseP = true;
    // }
    // if (ApiBaseHelper.allowOnlineDelivery!) {
    //   isOpenOnlineDelivery = true;
    //   print("ONLINE PICKUP jnj");

    //   isCloseOnlineDelivery = false;
    // } else {
    //   isOpenOnlineDelivery = false;
    //   print("ONLINE PICKUP");

    //   isCloseOnlineDelivery = true;
    // }
    // if (ApiBaseHelper.allowOnlinePickup!) {
    //   isOpenOnlinePickup = true;
    //   print("ONLINE PICKUP jnj");

    //   isCloseOnlinePickup = false;
    // } else {
    //   isOpenOnlinePickup = false;
    //   print("ONLINE PICKUP");

    //   isCloseOnlinePickup = true;
    // }
    // if (ApiBaseHelper.isReservationActive!) {
    //   isOpenReservation = true;
    //   print("ONLINE Reservation jnj");

    //   isCloseReservation = false;
    // } else {
    //   isOpenReservation = false;
    //   print("Reservation");

    //   isCloseReservation = true;
    // }
    getProfileData();
    clearImageCache();
    _restaurantDetailsRepository = new RestaurantDetailsRepository(context);
  }

  sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /* getLocalIP() async {
    String ip;
    try {
      ip = await Wifi.ip;
      print('local ip:\t$ip');
    } catch (e) {
      showMessage("WiFi is not connected", context);
      return;
    }
    setState(() {
      wifiController = new TextEditingController(text: ip);
    });
  }*/
  bool isOpenP = true, isCloseP = false;
  bool isOpenA = true, isCloseA = false;
  bool isOpenOnlineDelivery = true, isCloseOnlineDelivery = false;
  bool isOpenOnlinePickup = true, isCloseOnlinePickup = false;
  bool isOpenReservation = true, isCloseReservation = false;
  // bool ApiBaseHelper.autoPrint = ApiBaseHelper.autoPrint;
  // bool ApiBaseHelper.autoAccept = ApiBaseHelper.autoAccept;
  bool onlineDelivery = false;
  bool onlinePickup = false;
  bool reservation = false;
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
              wifiController = new TextEditingController(
                  text: defaultValue(model.data!.wifiPrinterIP, ""));
              wifiPortController = new TextEditingController(
                  text: defaultValue(model.data!.wifiPrinterPort, ""));
              deliveryController = new TextEditingController(
                  text: defaultValue(model.data!.deliveryRadius, ""));
              minimumController = new TextEditingController(
                  text: defaultValue(model.data!.minimumOrder, ""));
              webSiteUrl = new TextEditingController(
                  text: defaultValue(model.data!.websiteURL, ""));
              ApiBaseHelper.autoAccept = model.data!.autoAccept!;
              ApiBaseHelper.autoPrint = model.data!.autoPrint!;
              onlineDelivery = model.data!.allowOnlineDelivery!;
              onlinePickup = model.data!.allowOnlinePickup!;
              reservation = model.data!.isReservationActive!;
              if (model.data!.autoAccept == true) {
                isOpenA = true;
                isCloseA = false;
                print("ONLINE DELIVERY");
              } else {
                isOpenA = false;
                isCloseA = true;
                print("ONLINE mkckDELIVERY");
              }
              if (model.data!.autoPrint == true) {
                isOpenP = true;
                print("ONLINE PICKUP jnj");

                isCloseP = false;
              } else {
                isOpenP = false;
                print("ONLINE PICKUP");

                isCloseP = true;
              }
              if (model.data!.allowOnlineDelivery == true) {
                isOpenOnlineDelivery = true;
                print("ONLINE PICKUP jnj");

                isCloseOnlineDelivery = false;
              } else {
                isOpenOnlineDelivery = false;
                print("ONLINE PICKUP");

                isCloseOnlineDelivery = true;
              }
              if (model.data!.allowOnlinePickup == true) {
                isOpenOnlinePickup = true;
                print("ONLINE PICKUP jnj");

                isCloseOnlinePickup = false;
              } else {
                isOpenOnlinePickup = false;
                print("ONLINE PICKUP");
                isCloseOnlinePickup = true;
              }
              if (model.data!.isReservationActive == true) {
                isOpenReservation = true;
                print("ONLINE Reservation jnj");
                isCloseReservation = false;
              } else {
                isOpenReservation = false;
                print("Reservation");

                isCloseReservation = true;
              }
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

  callUpdateSetting() async {
    prefs.setString(ApiBaseHelper.ip, wifiController.text);
    prefs.setString(ApiBaseHelper.port, wifiPortController.text);
    prefs.setString(ApiBaseHelper.url, webSiteUrl.text);
    _restaurantDetailsRepository.updateSetting(
      wifiController,
      wifiPortController,
      deliveryController,
      minimumController,
      webSiteUrl,
      ApiBaseHelper.autoPrint.toString(),
      ApiBaseHelper.autoAccept.toString(),
      onlineDelivery.toString(),
      onlinePickup.toString(),
      reservation.toString(),
    );
  }

  callUploadBanner() async {
    if (cropperFile == null) {
      showMessage("Select your brand logo", context);
    } else {
      _restaurantDetailsRepository.updateRestaurantImageType(
          cropperFile!, IMAGE_COVER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: isDataLoad
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                color: colorGreen,
              ),
            )
          : Container(
              // padding: EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        child: Container(
                          // margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: colorTextWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: colorDividerGreen, width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: cropperFile == null
                                    ? resId.isEmpty
                                        ? SizedBox()
                                        : CachedNetworkImage(
                                            imageUrl:
                                                getImageURL(IMAGE_COVER, resId),
                                            imageBuilder:
                                                (imageContext, imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              );
                                            },
                                            errorWidget:
                                                (context, url, error) =>
                                                    SvgPicture.asset(
                                              placeHolder,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                            ),
                                          )
                                    : Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          image: DecorationImage(
                                              image: FileImage(cropperFile!),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 17,
                              ),
                              Text(
                                "Select your Cover Image",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // _optionsDialogBox();
                          // _pickerFile();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 30),
                                  decoration: BoxDecoration(
                                      color: colorButtonYellow,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "Upload",
                                    style: TextStyle(
                                        color: colorTextWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                                onTap: () {
                                  callUploadBanner();
                                  // print(cropperFile);
                                },
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      right: 20, left: 10),
                                  decoration: BoxDecoration(
                                      color: colorGrey,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: colorTextWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    // selectedBanner = null;
                                  });
                                },
                                behavior: HitTestBehavior.opaque,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      const Text(
                        "Add WiFi Printer",
                        style: TextStyle(
                            color: colorTextBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 19),
                        decoration: BoxDecoration(
                            color: colorTextWhite,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5)),
                            border:
                                Border.all(color: colorDividerGreen, width: 1)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                controller: wifiController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                decoration: const InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Enter IP Address",
                                  hintStyle: TextStyle(
                                      color: colorLightGrey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                                cursorColor: colorTextBlack,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                            GestureDetector(
                              child: SvgPicture.asset(
                                icEdit,
                                width: 22,
                                height: 22,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Add Port Number",
                        style: TextStyle(
                            color: colorTextBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 19),
                        decoration: BoxDecoration(
                            color: colorTextWhite,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5)),
                            border:
                                Border.all(color: colorDividerGreen, width: 1)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                controller: wifiPortController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Enter Port Number",
                                  hintStyle: TextStyle(
                                      color: colorLightGrey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                                cursorColor: colorTextBlack,
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                              ),
                            ),
                            GestureDetector(
                              child: SvgPicture.asset(
                                icEdit,
                                width: 22,
                                height: 22,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Add Delivery Radius in Km",
                        style: const TextStyle(
                            color: colorTextBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 19),
                        decoration: BoxDecoration(
                            color: colorTextWhite,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5)),
                            border:
                                Border.all(color: colorDividerGreen, width: 1)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                controller: deliveryController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Enter delivery radius",
                                  hintStyle: TextStyle(
                                      color: colorLightGrey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                                cursorColor: colorTextBlack,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            GestureDetector(
                              child: SvgPicture.asset(
                                icEdit,
                                width: 22,
                                height: 22,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Website Url",
                        style: const TextStyle(
                            color: colorTextBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 19),
                        decoration: BoxDecoration(
                            color: colorTextWhite,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: colorDividerGreen, width: 1)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                controller: webSiteUrl,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Enter Website url",
                                  hintStyle: TextStyle(
                                      color: colorTextBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                ),
                                cursorColor: colorTextBlack,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            GestureDetector(
                              child: SvgPicture.asset(
                                icEdit,
                                width: 22,
                                height: 22,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Auto Accept",
                            style: TextStyle(
                                color: colorTextBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(top: 19),
                            decoration: BoxDecoration(
                                color: colorTextWhite,
                                borderRadius: BorderRadius.circular(46),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(1.0, 1.0), //(x,y)
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
                                        color: isOpenA
                                            ? colorGreen
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Activate",
                                      style: TextStyle(
                                        color: isOpenA
                                            ? colorTextWhite
                                            : colorGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isOpenA) {
                                      setState(() {
                                        isOpenA = true;
                                        isCloseA = false;
                                        ApiBaseHelper.autoAccept = true;
                                        print("Auto Accept" +
                                            ApiBaseHelper.autoAccept
                                                .toString());
                                        // delsetting =
                                        //     "Open Online Delivery";
                                      });
                                      // callApi("true", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: isCloseA
                                            ? colorButtonYellow
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Deactivate",
                                      style: TextStyle(
                                        color: isCloseA
                                            ? colorTextWhite
                                            : colorButtonYellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isCloseA) {
                                      setState(() {
                                        isOpenA = false;
                                        isCloseA = true;
                                        ApiBaseHelper.autoAccept = false;
                                        print("Auto Accept" +
                                            ApiBaseHelper.autoAccept
                                                .toString());
                                        // delsetting =
                                        // "Close Online Delivery";
                                      });
                                      // callApi("false", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Auto Print",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(top: 19),
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
                                        color: isOpenP
                                            ? colorGreen
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Activate",
                                      style: TextStyle(
                                        color: isOpenP
                                            ? colorTextWhite
                                            : colorGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isOpenP) {
                                      setState(() {
                                        isOpenP = true;
                                        isCloseP = false;
                                        ApiBaseHelper.autoPrint = true;
                                        // delsetting =
                                        //     "Open Online Delivery";
                                      });
                                      // callApi("true", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: isCloseP
                                            ? colorButtonYellow
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Deactivate",
                                      style: TextStyle(
                                        color: isCloseP
                                            ? colorTextWhite
                                            : colorButtonYellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isCloseP) {
                                      setState(() {
                                        isOpenP = false;
                                        isCloseP = true;
                                        ApiBaseHelper.autoPrint = false;
                                        // delsetting =
                                        // "Close Online Delivery";
                                      });
                                      // callApi("false", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                              ],
                            ),
                          ),
                          // Transform.scale(
                          //   scale: 1.0,
                          //   child: CupertinoSwitch(
                          //     value: ApiBaseHelper.autoPrint!,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         ApiBaseHelper.autoPrint =
                          //             !ApiBaseHelper.autoPrint!;
                          //         print(ApiBaseHelper.autoPrint);
                          //       });
                          //     },
                          //     activeColor: colorGreen,
                          //     trackColor: colorSwitchColor,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Allow Online Delivery",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(top: 19),
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
                                        color: isOpenOnlineDelivery
                                            ? colorGreen
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Activate",
                                      style: TextStyle(
                                        color: isOpenOnlineDelivery
                                            ? colorTextWhite
                                            : colorGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isOpenOnlineDelivery) {
                                      setState(() {
                                        isOpenOnlineDelivery = true;
                                        isCloseOnlineDelivery = false;
                                        onlineDelivery = true;
                                        // delsetting =
                                        //     "Open Online Delivery";
                                      });
                                      // callApi("true", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: isCloseOnlineDelivery
                                            ? colorButtonYellow
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Deactivate",
                                      style: TextStyle(
                                        color: isCloseOnlineDelivery
                                            ? colorTextWhite
                                            : colorButtonYellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isCloseOnlineDelivery) {
                                      setState(() {
                                        isOpenOnlineDelivery = false;
                                        isCloseOnlineDelivery = true;
                                        onlineDelivery = false;
                                        // delsetting =
                                        // "Close Online Delivery";
                                      });
                                      // callApi("false", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                              ],
                            ),
                          ),
                          // Transform.scale(
                          //   scale: 1.0,
                          //   child: CupertinoSwitch(
                          //     value: ApiBaseHelper.autoPrint!,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         ApiBaseHelper.autoPrint =
                          //             !ApiBaseHelper.autoPrint!;
                          //         print(ApiBaseHelper.autoPrint);
                          //       });
                          //     },
                          //     activeColor: colorGreen,
                          //     trackColor: colorSwitchColor,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Allow Online Pickup",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(top: 19),
                            decoration: BoxDecoration(
                                color: colorTextWhite,
                                borderRadius: BorderRadius.circular(46),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(1.0, 1.0), //(x,y)
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
                                        color: isOpenOnlinePickup
                                            ? colorGreen
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Activate",
                                      style: TextStyle(
                                        color: isOpenOnlinePickup
                                            ? colorTextWhite
                                            : colorGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isOpenOnlinePickup) {
                                      setState(() {
                                        isOpenOnlinePickup = true;
                                        isCloseOnlinePickup = false;
                                        onlinePickup = true;
                                        // delsetting =
                                        //     "Open Online Delivery";
                                      });
                                      // callApi("true", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: isCloseOnlinePickup
                                            ? colorButtonYellow
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Deactivate",
                                      style: TextStyle(
                                        color: isCloseOnlinePickup
                                            ? colorTextWhite
                                            : colorButtonYellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isCloseOnlinePickup) {
                                      setState(() {
                                        isOpenOnlinePickup = false;
                                        isCloseOnlinePickup = true;
                                        onlinePickup = false;
                                        // delsetting =
                                        // "Close Online Delivery";
                                      });
                                      // callApi("false", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                              ],
                            ),
                          ),
                          // Transform.scale(
                          //   scale: 1.0,
                          //   child: CupertinoSwitch(
                          //     value: ApiBaseHelper.autoPrint!,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         ApiBaseHelper.autoPrint =
                          //             !ApiBaseHelper.autoPrint!;
                          //         print(ApiBaseHelper.autoPrint);
                          //       });
                          //     },
                          //     activeColor: colorGreen,
                          //     trackColor: colorSwitchColor,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Online Reservation",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            // padding: EdgeInsets.all(18),
                            margin: const EdgeInsets.only(top: 19),
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
                                        color: isOpenReservation
                                            ? colorGreen
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Activate",
                                      style: TextStyle(
                                        color: isOpenReservation
                                            ? colorTextWhite
                                            : colorGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isOpenReservation) {
                                      setState(() {
                                        isOpenReservation = true;
                                        isCloseReservation = false;
                                        reservation = true;
                                        print("object 1" +
                                            reservation.toString());
                                      });
                                      // callApi("true", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: isCloseReservation
                                            ? colorButtonYellow
                                            : colorTextWhite,
                                        borderRadius:
                                            BorderRadius.circular(46)),
                                    child: Text(
                                      "Deactivate",
                                      style: TextStyle(
                                        color: isCloseReservation
                                            ? colorTextWhite
                                            : colorButtonYellow,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isCloseReservation) {
                                      setState(() {
                                        isOpenReservation = false;
                                        isCloseReservation = true;
                                        reservation = false;
                                        print(
                                            "object" + reservation.toString());
                                      });
                                      // callApi("false", "Del");
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                )),
                              ],
                            ),
                          ),
                          // Transform.scale(
                          //   scale: 1.0,
                          //   child: CupertinoSwitch(
                          //     value: ApiBaseHelper.autoPrint!,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         ApiBaseHelper.autoPrint =
                          //             !ApiBaseHelper.autoPrint!;
                          //         print(ApiBaseHelper.autoPrint);
                          //       });
                          //     },
                          //     activeColor: colorGreen,
                          //     trackColor: colorSwitchColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(right: 10, left: 30),
                              decoration: BoxDecoration(
                                  color: colorButtonYellow,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              print("Auto Data Feed" +
                                  ApiBaseHelper.autoAccept.toString());
                              callUpdateSetting();
                            },
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(right: 20, left: 10),
                              decoration: BoxDecoration(
                                  color: colorGrey,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                deliveryController =
                                    TextEditingController(text: "");
                                wifiController =
                                    TextEditingController(text: "");
                                wifiPortController =
                                    TextEditingController(text: "");
                                minimumController =
                                    TextEditingController(text: "");
                                webSiteUrl = TextEditingController(text: "");
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext _context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text(
                      'Take a picture',
                      style: TextStyle(color: colorTextBlack, fontSize: 22),
                    ),
                    onTap: () {
                      setState(() async {
                        // ImagePicker.platform
                        //     .pickImage(source: ImageSource.camera)
                        //     .then((value) {
                        //   setState(() {
                        //     selectedBanner = value!;
                        //     _cropImage(selectedBanner!.path);
                        //   });
                        // });
                        Navigator.pop(_context);
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: const Text(
                      'Select from gallery',
                      style: TextStyle(color: colorTextBlack, fontSize: 22),
                    ),
                    onTap: () {
                      // _pickerFile();
                      // ImagePicker.platform
                      //     .pickImage(source: ImageSource.gallery)
                      //     .then((value) {
                      //   setState(() {
                      //     selectedBanner = value!;
                      //     _cropImage(selectedBanner!.path);
                      //   });
                      // });
                      // Navigator.pop(_context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // void _pickerFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.image, allowedExtensions: ['jpg', 'jpeg,', 'png']);
  //   if (result == null) return;
  //   PlatformFile file = result.files.single;
  //   setState(() {
  //     cropperFile = File(file.path!);
  //   });
  // }

  clearImageCache() async {
    resId.isEmpty
        ? ""
        : await CachedNetworkImage.evictFromCache(
            getImageURL(IMAGE_COVER, resId));
  }
}
