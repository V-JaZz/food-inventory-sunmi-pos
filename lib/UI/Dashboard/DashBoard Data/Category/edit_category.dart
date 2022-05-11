import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/dashboard/DashBoard%20Data/Category/repository/category_repository.dart';
import 'package:food_inventory/UI/dashboard/DashBoard%20Data/Category/seeAll.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditCategory extends StatefulWidget {
  VoidCallback onDialogClose;
  String id;
  String name;
  String discount;
  String description;
  String image;
  EditCategory(
      {Key? key,
      required this.onDialogClose,
      required this.id,
      required this.name,
      required this.description,
      required this.discount,
      required this.image})
      : super(key: key);
  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late CategoryRepository _categoryRepository;
  String id = "";
  late TextEditingController _nameController;
  late TextEditingController _discountController;
  late TextEditingController _descriptionController;
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

  PickedFile? selectedBanner;
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
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    onTap: () {
                      // setState(() async {
                      // ignore: invalid_use_of_visible_for_testing_member
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: const Text(
                      'Select from gallery',
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    onTap: () {
                      // ignore: invalid_use_of_visible_for_testing_member
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
    id = widget.id;
    _categoryRepository = CategoryRepository(context);
    _nameController = TextEditingController(text: widget.name);
    _discountController = TextEditingController(text: widget.discount);
    _descriptionController = TextEditingController(text: widget.description);
  }

  calleditCategoryApi() async {
    cropperFile != null
        ? _categoryRepository.editCategory(
            widget.id,
            _nameController.text.toString().trim(),
            _descriptionController.text.toString().trim(),
            _discountController.text.toString().trim(),
            cropperFile!)
        : _categoryRepository.editCategorywithoutImage(
            widget.id,
            _nameController.text.toString().trim(),
            _descriptionController.text.toString().trim(),
            _discountController.text.toString().trim(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.all(15.0),
          elevation: 0,
          // backgroundColor: Colors.transparent,
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Edit Category",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _nameController,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Category Name",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),
                    child: TextField(
                      maxLines: 1,
                      controller: _discountController,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: const InputDecoration(
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
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),
                    child: TextField(
                      maxLines: 1,
                      controller: _descriptionController,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Add Discription",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    widget.image.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              // _optionsDialogBox();
                              _optionsDialogBox();
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.30,
                              // color: Colors.red,
                              child: cropperFile == null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          getImageCatURL("category", widget.id),
                                      imageBuilder:
                                          (imageContext, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(7)),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        placeHolder,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.10,
                                      ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.10,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                            image: FileImage(cropperFile!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                            ),
                          )
                        : cropperFile != null
                            ? GestureDetector(
                                onTap: () {
                                  // _optionsDialogBox();
                                  _optionsDialogBox();
                                },
                                child: Container(
                                  height: 100,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                        image: FileImage(cropperFile!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.add_circle,
                                      color: colorYellow,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      "Add Category Image",
                                      style: TextStyle(
                                          color: colorBlack,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // _optionsDialogBox();
                                  _optionsDialogBox();
                                },
                              ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorButtonYellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            // if (_nameController.text.isEmpty) {
                            //   showMessage("Enter Category Name", context);
                            // } else if (_descriptionController.text.isEmpty) {
                            //   showMessage("Enter Discription Name", context);
                            // } else if (_discountController.text.isEmpty) {
                            //   showMessage("Enter Discount Name", context);
                            // } else {
                            //   callAddCategoryApi();
                            // }
                            calleditCategoryApi();
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 8, right: 30),
                            decoration: BoxDecoration(
                                color: colorGrey,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
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
