// ignore_for_file: unused_field, unused_local_variable, unused_element, invalid_use_of_visible_for_testing_member
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:food_inventory/UI/RestaurantDetails/repository/restaurant_details_repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/login_model.dart';

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({Key? key}) : super(key: key);

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController collectionTimeController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  bool isDataLoad = true;
  late RestaurantDetailsRepository _restaurantDetailsRepository;
  late TimeOfDay selectedStartTime, selectedEndTime;
  String _startDay = "", _endDay = "";
  File? cropperFile;
  Future<void> _cropImage(path) async {
    ImageCropper imageCropper = ImageCropper();
    File? croppedFile = await imageCropper.cropImage(
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

    if (croppedFile != null) {
      cropperFile = croppedFile;
      callUploadLogo();
      setState(() {});
    } else {
    }
  }

  final List<String> _dayList = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  String resId = '';
  PickedFile? selectedLogo;

  @override
  void initState() {
    super.initState();
    clearImageCache();
    getLoginData();
    _sessionToken = uuid.v4();
    _restaurantDetailsRepository = RestaurantDetailsRepository(context);
    selectedEndTime = TimeOfDay.now();
  }

  late String _sessionToken;
  var uuid = const Uuid(options: {'grng': UuidUtil.cryptoRNG});
  static const kGoogleApiKey = "AIzaSyAhywc-2JvaX6jkQ_r_eTefqVi-Iy5hv08";
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  getLoginData() async {
    StorageUtil.getData(StorageUtil.keyLoginData, "")!.then((value) {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((id) async {
        setState(() {
          isDataLoad = false;
          resId = id;
        });
        if (value != null && value != "") {
          setState(() {
            LoginData loginData = LoginData.fromJson(jsonDecode(value));

            nameController = TextEditingController(
                text: defaultValue(loginData.restaurantName!, ""));
            addressController = TextEditingController(
                text: defaultValue(loginData.location!, ""));

            if (loginData.passcode != null) {
              if (loginData.passcode!.isNotEmpty) {
                postcodeController = TextEditingController(
                    text: defaultValue(loginData.passcode![0], ""));
              }
            } else {
              postcodeController = TextEditingController(
                  text: defaultValue(loginData.passcode![0], ""));
            }
            phoneController = TextEditingController(
                text: defaultValue(loginData.phoneNumber!, ""));
            if (loginData.restEmail != null) {
              if (loginData.restEmail!.isNotEmpty) {
                emailController = TextEditingController(
                    text: defaultValue(loginData.restEmail!, ""));
              }
            } else {
              emailController = TextEditingController(text: "");
            }
            if (loginData.vatNumber != null) {
              if (loginData.vatNumber!.isNotEmpty) {
                vatController = TextEditingController(
                    text: defaultValue(loginData.vatNumber!, ""));
              }
            } else {
              vatController = TextEditingController(
                  text: defaultValue(loginData.vatNumber, ""));
            }

            if (checkString(loginData.openTime)) {
              selectedStartTime = TimeOfDay.now();
            } else {
              selectedStartTime = TimeOfDay(
                  hour: int.parse(loginData.openTime!.split(":")[0]),
                  minute: int.parse(loginData.openTime!.split(":")[1]));
            }
            if (checkString(loginData.closeTime)) {
              selectedEndTime = TimeOfDay.now();
            } else {
              selectedEndTime = TimeOfDay(
                  hour: int.parse(loginData.closeTime!.split(":")[0]),
                  minute: int.parse(loginData.closeTime!.split(":")[1]));
            }
            deliveryTimeController = TextEditingController(
                text: defaultValue(loginData.deliveryTime, ""));
            collectionTimeController = TextEditingController(
                text: defaultValue(loginData.collectionTime, ""));
            _startDay = defaultValue(loginData.openDay, "");
            _endDay = defaultValue(loginData.closeDay, "");
          });
        }
      });
    });
  }

  Future<void> displayPrediction(Prediction p) async {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId.toString());

    var placeId = p.placeId;
    double lat = detail.result.geometry!.location.lat;
    double lng = detail.result.geometry!.location.lng;
    setState(() {
      addressController.text = detail.result.formattedAddress!;
      postcodeController.text = detail.result.placeId;
    });
  }

  callUpdateProfile() async {
    _restaurantDetailsRepository.updateProfile(
        nameController,
        addressController,
        postcodeController,
        phoneController,
        emailController,
        vatController,
        deliveryTimeController,
        collectionTimeController
        /*  selectedStartTime,
        selectedEndTime,
        _startDay,
        _endDay*/
        );
  }

  callUploadLogo() async {
    if (cropperFile == null) {
      showMessage("Select your brand logo", context);
    } else {
      _restaurantDetailsRepository.updateRestaurantImageType(
          cropperFile!, IMAGE_ICON);
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: const RouteSettings(),
      initialTime: selectedStartTime,
      builder: (BuildContext _context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(_context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: const RouteSettings(),
      initialTime: selectedEndTime,
      builder: (BuildContext _context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(_context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
      });
    }
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
                        ImagePicker.platform
                            .pickImage(source: ImageSource.camera)
                            .then((value) {
                          setState(() {
                            selectedLogo = value!;
                            _cropImage(selectedLogo!.path);
                          });
                        });
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
                      ImagePicker.platform
                          .pickImage(source: ImageSource.gallery)
                          .then((value) {
                        setState(() {
                          selectedLogo = value!;
                          _cropImage(selectedLogo!.path);
                        });
                      });
                      Navigator.pop(_context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // void _pickerFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result == null) return;
  //   PlatformFile file = result.files.single;
  //   print(file.path);
  //   setState(() {
  //     cropperFile = File(file.path!);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    /*return ScreenUtilInit(
      builder: () {
      },
    );*/
    return Container(
      child: isDataLoad
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                color: colorGreen,
              ),
            )
          : ListView(
              children: [
                Column(
                  children: [
                    const Text(
                      "Restaurant Details",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.42,
                                // decoration: BoxDecoration(
                                //   color: colorTextWhite,
                                //   borderRadius: BorderRadius.all(Radius.circular(15)),
                                // ),
                                child: Card(
                                  // clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: cropperFile == null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              getImageURL(IMAGE_ICON, resId),
                                          imageBuilder:
                                              (imageContext, imageProvider) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(20)),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill),
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              SvgPicture.asset(placeHolder,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.42,
                                                  fit: BoxFit.fitWidth),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.42,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            image: DecorationImage(
                                                image: FileImage(cropperFile!),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                ),
                              ),
                              SvgPicture.asset(
                                placeHol,
                                height: 40,
                                width: 50,
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        _optionsDialogBox();
                      },
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    const Text(
                      "Brand Logo",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 30,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: colorTextWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          ListView(
                            primary: false,
                            // padding: EdgeInsets.symmetric(vertical: 45),
                            shrinkWrap: true,
                            children: [
                              TextField(
                                maxLines: 1,
                                controller: nameController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: colorTextBlack),
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    // contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: "Restaurant Name",
                                    labelText: "Restaurant Name",
                                    labelStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    hintStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    suffix: GestureDetector(
                                      child: SvgPicture.asset(
                                        icFeather,
                                        width: 22,
                                        height: 22,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                maxLines: 1,
                                controller: addressController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: colorTextBlack),
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    // contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: "Full Address",
                                    labelText: "Full Address",
                                    labelStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    hintStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    suffix: GestureDetector(
                                      child: SvgPicture.asset(
                                        icLocation,
                                        width: 22,
                                        height: 22,
                                      ),
                                    )),
                                onTap: () async {
                                  Prediction? p = await PlacesAutocomplete.show(
                                      strictbounds: false,
                                      region: "DE",
                                      language: "DE",
                                      context: context,
                                      mode: Mode.overlay,
                                      apiKey: kGoogleApiKey,
                                      sessionToken: _sessionToken,
                                      components: [
                                        Component(Component.country, "DE")
                                      ],
                                      types: [],
                                      hint: "Search City",
                                      startText: '');

                                  displayPrediction(p!);
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                maxLines: 1,
                                controller: phoneController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: colorTextBlack),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colorTextHint)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colorTextHint)),
                                  // contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Phone Number",
                                  labelText: "Phone Number",
                                  labelStyle: const TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  hintStyle: const TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  suffix: GestureDetector(
                                      child: SvgPicture.asset(
                                    icFeather,
                                    width: 22,
                                    height: 22,
                                  )),
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colorTextHint)),
                                ),
                                cursorColor: colorTextBlack,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                maxLines: 1,
                                controller: emailController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: colorTextBlack),
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    // contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: "Email Address",
                                    labelText: "Email Address",
                                    labelStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    hintStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    suffix: GestureDetector(
                                        child: SvgPicture.asset(
                                      icFeather,
                                      width: 22,
                                      height: 22,
                                    )),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint))),
                                cursorColor: colorTextBlack,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                maxLines: 1,
                                controller: vatController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: colorTextBlack),
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    // contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: "VAT Number",
                                    labelText: "VAT Number",
                                    suffix: GestureDetector(
                                        child: SvgPicture.asset(
                                      icFeather,
                                      width: 22,
                                      height: 22,
                                    )),
                                    labelStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    hintStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint))),
                                cursorColor: colorTextBlack,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                maxLines: 1,
                                controller: collectionTimeController,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: colorTextBlack),
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint)),
                                    // contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    hintText: "Collection Time",
                                    suffix: GestureDetector(
                                        child: SvgPicture.asset(
                                      icFeather,
                                      width: 22,
                                      height: 22,
                                    )),
                                    labelText: "Collection Time",
                                    labelStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    hintStyle: const TextStyle(
                                        color: colorTextHint, fontSize: 16),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorTextHint))),
                                cursorColor: colorTextBlack,
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          left: 30, right: 10),
                                      decoration: BoxDecoration(
                                          color: colorGreen,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(
                                            color: colorTextWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                    ),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      callUpdateProfile();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 30),
                                      decoration: BoxDecoration(
                                          color: colorGrey,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Text(
                                        "Reset",
                                        style: TextStyle(
                                            color: colorTextWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        nameController =
                                            TextEditingController(text: "");
                                        addressController =
                                            TextEditingController(text: "");
                                        postcodeController =
                                            TextEditingController(text: "");
                                        phoneController =
                                            TextEditingController(text: "");
                                        emailController =
                                            TextEditingController(text: "");
                                        vatController =
                                            TextEditingController(text: "");
                                        deliveryTimeController =
                                            TextEditingController(text: "");
                                        collectionTimeController =
                                            TextEditingController(text: "");
                                        selectedStartTime = TimeOfDay.now();
                                        selectedEndTime = TimeOfDay.now();
                                        _startDay = "";
                                        _endDay = "";
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
                  ],
                ),
              ],
            ),
    );
  }

  clearImageCache() async {
    await CachedNetworkImage.evictFromCache(getImageURL(IMAGE_ICON, resId));
  }
}
