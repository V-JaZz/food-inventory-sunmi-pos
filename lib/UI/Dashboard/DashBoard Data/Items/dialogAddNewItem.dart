import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DialogAddNewItems extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  DialogAddNewItems({required this.onDialogClose});

  @override
  _DialogAddNewItemsState createState() => _DialogAddNewItemsState();
}

class _DialogAddNewItemsState extends State<DialogAddNewItems> {
  late TextEditingController _addNewController;
  late TextEditingController _discriptionController;
  late TextEditingController _discountController;
  late TextEditingController _variantController;
  late TextEditingController _optionController;
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
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: colorButtonYellow,
            toolbarWidgetColor: colorButtonBlue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedfile != null) {
      cropperFile = croppedfile;
      setState(() {});
    } else {
      print("Image is not cropped.");
    }
  }

  PickedFile? selectedBanner;
  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext _context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text(
                      'Take a picture',
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    onTap: () {
                      // setState(() async {
                      ImagePicker.platform
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        setState(() {
                          selectedBanner = value!;
                          _cropImage(selectedBanner!.path);
                        });
                        // });
                        Navigator.pop(_context);
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text(
                      'Select from gallery',
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    onTap: () {
                      ImagePicker.platform
                          .pickImage(source: ImageSource.gallery)
                          .then((value) {
                        setState(() {
                          selectedBanner = value!;
                          _cropImage(selectedBanner!.path);
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

  @override
  void initState() {
    super.initState();
    _addNewController = new TextEditingController();
    _discriptionController = new TextEditingController();
    _discountController = new TextEditingController();
    _variantController = new TextEditingController();
    _optionController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: EdgeInsets.all(15.0),
          elevation: 0,
          // backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.785,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add New Item",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    cropperFile != null
                        ? GestureDetector(
                            onTap: () {
                              _optionsDialogBox();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.20,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: FileImage(cropperFile!),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              _optionsDialogBox();
                            },
                            child: Icon(Icons.add_circle,
                                size: 32, color: colorButtonYellow))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _addNewController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "New Item",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _addNewController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Select Category",
                              hintStyle: TextStyle(
                                  color: colorTextHint,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _addNewController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Select Allergy Group",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _discriptionController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Add Discription",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _discountController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Add Discount",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _variantController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Select Variant",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 60,
                            color: Color.fromRGBO(213, 210, 234, 1),
                            height: MediaQuery.of(context).size.width * 0.14,
                            child: Text("0.00",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400))),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(05),
                                bottomRight: Radius.circular(05)),
                          ),
                          child: SvgPicture.asset(
                            icCurrency,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 05),
                GestureDetector(
                  child: Text(
                    "+ Add More",
                    style: TextStyle(
                        color: colorButtonYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _optionController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Select Option",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 60,
                            color: Color.fromRGBO(213, 210, 234, 1),
                            height: MediaQuery.of(context).size.width * 0.14,
                            child: Text("0.00",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400))),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(05),
                                bottomRight: Radius.circular(05)),
                          ),
                          child: SvgPicture.asset(
                            icCurrency,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 05),
                GestureDetector(
                  child: Text(
                    "+ Add More",
                    style: TextStyle(
                        color: colorButtonYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorButtonYellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 8, right: 30),
                            decoration: BoxDecoration(
                                color: colorGrey,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          behavior: HitTestBehavior.opaque,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
