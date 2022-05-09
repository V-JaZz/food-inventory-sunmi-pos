import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/DashBoard%20Data/Category/seeAll.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DialogAddNewCategory extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  DialogAddNewCategory({required this.onDialogClose});
  @override
  State<DialogAddNewCategory> createState() => _DialogAddNewCategoryState();
}

class _DialogAddNewCategoryState extends State<DialogAddNewCategory> {
  late TextEditingController _categoryNameController;
  late TextEditingController _addDiscountController;
  late TextEditingController _discriptionController;
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
    _categoryNameController = new TextEditingController();
    _addDiscountController = new TextEditingController();
    _discriptionController = new TextEditingController();
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
            // height: MediaQuery.of(context).size.height * 0.65,
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
                      "Add New Category",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        seeAllDialog("See All Category");
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text("See All",
                            style: TextStyle(
                                color: colorTextWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 13)),
                      ),
                    )
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
                      controller: _categoryNameController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Category Name",
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
                      controller: _addDiscountController,
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
                          border: InputBorder.none,
                          suffix: Text("%",
                              style: TextStyle(
                                  color: colorButtonYellow,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500))),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),
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
                Row(
                  children: [
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
                                size: 32, color: colorButtonYellow)),
                    SizedBox(width: 10),
                    Text("Add Category Image",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700))
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
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

  void seeAllDialog(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ListAllPage(
          onDialogClose: () {},
        );
      },
    );
  }
}
