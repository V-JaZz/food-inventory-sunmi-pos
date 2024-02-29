// ignore_for_file: avoid_print, avoid_unnecessary_containers
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/dialogAddNewItem.dart';
// import 'package:food_inventory/UI/dashboard/forms/Items/model/menu_items.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';

import 'menu_item_repository.dart';
import 'model/menu_items.dart';

// ignore: must_be_immutable
class DialogMenuItems extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var isEdit;
  Items? editItem;
  String type;
  VoidCallback onAddDeleteSuccess;

  DialogMenuItems(
      {Key? key,
      this.isEdit,
      this.editItem,
      required this.type,
      required this.onAddDeleteSuccess})
      : super(key: key);

  @override
  _DialogMenuItemsState createState() => _DialogMenuItemsState();
}

class _DialogMenuItemsState extends State<DialogMenuItems> {
  late String selectedValue;
  List<String> dropDownOption = ["Online Order Menu", "Table Order Menu"];
  late String selectedType;
  List<SelectOptionData> optionData = [];
  List<SelectVariantData> variantData = [];
  bool isOpen = true, isClose = false;
  late SelectionMenuDataList _categoryData, _allergyGroupData;
  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountController;
  late MenuItemRepository _itemRepository;
  bool isShowAddMoreOption = true;
  bool isShowAddMore = true;
  bool isDataLoad = false;
  File? cropperFile;

  clearImageCache(id) async {
    await CachedNetworkImage.evictFromCache(getImageCatURL("item", id));
  }

  @override
  void initState() {
    super.initState();
    _itemRepository = MenuItemRepository(context, widget);
    optionData = [];
    variantData = [];
    selectedValue =
        widget.type == "Menu" ? 'Online Order Menu' : "Table Order Menu";
    selectedType = widget.type == "Menu" ? "online" : "table";
    if (widget.isEdit) {
      clearImageCache(widget.editItem!.sId!);
      if (widget.editItem!.options!.isNotEmpty) {
        isShowAddMoreOption = true;
        print("OPTIONIS WORKING NIT");
        for (int i = 0; i < widget.editItem!.options!.length; i++) {
          print("JSJSJJSJ" + widget.editItem!.options![i].price.toString());
          print("OPTIONIS WORKING NIT");

          optionData.add(SelectOptionData(
              SelectionMenuDataList(
                  "",
                  "Default Option",
                  defaultValue(widget.editItem!.options![i].price, "0.0"),
                  0.0,
                  0.0,
                  "",
                  "",
                  false),
              TextEditingController(
                  text: defaultValue(
                      widget.editItem!.options![i].price, "0.0"))));
        }
      } else {
        // for (Options data in widget.editItem!.options!) {
        print("OPTIONIS WORKING");
        optionData.add(SelectOptionData(
            SelectionMenuDataList("", "Default Option", widget.editItem!.price!,
                0.0, 0.0, "", "", true),
            TextEditingController(text: widget.editItem!.price!)));
        // }
      }
      if (widget.editItem!.variants!.isNotEmpty) {
        isShowAddMore = true;
        print("VARIANTY WORKING NIT");
        for (int i = 0; i < widget.editItem!.variants!.length; i++) {
          print("JSJSJJSJ" + widget.editItem!.variants![i].price.toString());
          variantData.add(SelectVariantData(
              SelectionMenuDataList(
                  "",
                  "Default Variant",
                  defaultValue(widget.editItem!.variants![i].price, "0.0"),
                  0.0,
                  0.0,
                  "",
                  "",
                  false),
              TextEditingController(
                  text: defaultValue(
                      widget.editItem!.variants![i].price, "0.0"))));
        }
      } else {
        print("VARIANTY WORKING");
        // for (Variants data in widget.editItem!.variants!) {
        variantData.add(SelectVariantData(
            SelectionMenuDataList(
                "", "Default Variant", "0.0", 0.0, 0.0, "", "", true),
            TextEditingController(text: "0.0")));
        // }
      }
      _itemNameController = TextEditingController(text: widget.editItem!.name);
      _descriptionController =
          TextEditingController(text: widget.editItem!.description);
      _discountController =
          TextEditingController(text: widget.editItem!.discount.toString());

      _categoryData = SelectionMenuDataList(widget.editItem!.category!.sId!,
          widget.editItem!.category!.name!, "", 0.0, 0.0, "", "", true);
      _allergyGroupData = SelectionMenuDataList(
          defaultValue(widget.editItem!.allergyGroups!.sId, ""),
          defaultValue(
              widget.editItem!.allergyGroups!.name, "Default Allergy Group"),
          "",
          0.0,
          0.0,
          '',
          "",
          false);
    } else {
      var option = SelectionMenuDataList(
          '', 'Default Option', '', 0.0, 0.0, '', "", false);
      var variant = SelectionMenuDataList(
          '', 'Default Option', '', 0.0, 0.0, '', "", false);
      optionData.add(SelectOptionData(option, TextEditingController()));
      variantData.add(SelectVariantData(variant, TextEditingController()));
      _discountController = TextEditingController();
      _itemNameController = TextEditingController();
      _descriptionController = TextEditingController();
      _allergyGroupData = SelectionMenuDataList(
          "", "Default Allergy Group", "", 0.0, 0.0, '', "", false);
      _categoryData =
          SelectionMenuDataList("", "", "", 0.0, 0.0, '', "", false);
    }
  }

  callAddItemApi() async {
    cropperFile == null
        ? _itemRepository.addMenuItemwithoutimage(
            _itemNameController,
            _descriptionController,
            _discountController,
            _categoryData,
            variantData,
            optionData,
            _allergyGroupData,
            selectedType)
        : _itemRepository.addMenuItem(
            _itemNameController,
            _descriptionController,
            _discountController,
            _categoryData,
            variantData,
            optionData,
            _allergyGroupData,
            cropperFile!,
            selectedType);
  }

  callEditItemApi() async {
    cropperFile == null
        ? _itemRepository.editMenuItem(
            widget.editItem!.sId!,
            _itemNameController,
            _descriptionController,
            _categoryData,
            variantData,
            optionData,
            _allergyGroupData,
            _discountController,
            selectedType)
        : _itemRepository.editMenuItemwithImage(
            widget.editItem!.sId!,
            _itemNameController,
            _descriptionController,
            _categoryData,
            variantData,
            optionData,
            _allergyGroupData,
            _discountController,
            cropperFile!,
            selectedType);
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
            height: MediaQuery.of(context).size.height * 0.785,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEdit ? "Edit Item" : "Add New Item",
                      style: const TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    widget.isEdit
                        ? widget.editItem!.imageName!.isNotEmpty &&
                                cropperFile == null
                            ? GestureDetector(
                                onTap: () {
                                  _pickerFile();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(33.0),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    child: CachedNetworkImage(
                                      imageUrl: getImageCatURL(
                                          "item", widget.editItem!.sId!),
                                      imageBuilder:
                                          (imageContext, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(33)),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        placeHolder,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                      ),
                                    )),
                              )
                            : Container(
                                child: cropperFile != null
                                    ? GestureDetector(
                                        onTap: () {
                                          _pickerFile();
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(33)),
                                            image: DecorationImage(
                                                image: FileImage(cropperFile!),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Add image",
                                              style: TextStyle(
                                                  color: colorTextBlack,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Icon(
                                              Icons.add_circle,
                                              color: colorYellow,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          _pickerFile();
                                        },
                                      ),
                              )
                        : Container(
                            child: cropperFile != null
                                ? GestureDetector(
                                    onTap: () {
                                      _pickerFile();
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(33)),
                                        image: DecorationImage(
                                            image: FileImage(cropperFile!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Add image",
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Icon(
                                          Icons.add_circle,
                                          color: colorYellow,
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      _pickerFile();
                                    },
                                  ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(15.0),
                        padding: const EdgeInsets.only(left: 05, right: 05),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(223, 221, 239, 1),
                            borderRadius: BorderRadius.circular(05)),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            value: selectedValue,
                            items: dropDownOption.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: colorTextBlack,
                                  ),
                                ),
                              );
                            }).toList(),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                                if (value == "Online Order Menu") {
                                  selectedType = "online";
                                } else if (value == "Table Order Menu") {
                                  selectedType = "table";
                                } else {
                                  print("DATA FALSE: NULL");
                                }
                                print("Selected Type: " + selectedType);
                              });
                            }),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(223, 221, 239, 1),
                            borderRadius: BorderRadius.circular(05)),
                        child: TextField(
                          maxLines: 1,
                          controller: _itemNameController,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: colorTextBlack),
                          cursorColor: colorTextBlack,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Enter Item Name",
                              hintStyle: TextStyle(
                                  color: colorTextHint,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(223, 221, 239, 1),
                            borderRadius: BorderRadius.circular(05)),
                        child: GestureDetector(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              _categoryData.name.isEmpty
                                  ? "Select Category"
                                  : _categoryData.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: _categoryData.name.isEmpty
                                      ? colorTextHint
                                      : colorTextBlack),
                            ),
                          ),
                          onTap: () {
                            selectTypeData(TYPE_CATEGORY, -1, _categoryData);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(223, 221, 239, 1),
                            borderRadius: BorderRadius.circular(05)),
                        child: GestureDetector(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              // ignore: unnecessary_null_comparison
                              _allergyGroupData == null
                                  ? "Select Allergy Group"
                                  : _allergyGroupData.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  // ignore: unnecessary_null_comparison
                                  color: _allergyGroupData == null
                                      ? colorTextHint
                                      : colorTextBlack),
                            ),
                          ),
                          onTap: () {
                            selectTypeData(
                                TYPE_ALLERGY_GROUP, -1, _allergyGroupData);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                              hintText: "Description",
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(223, 221, 239, 1),
                            borderRadius: BorderRadius.circular(05)),
                        child: TextField(
                          maxLines: 1,
                          controller: _discountController,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: colorTextBlack),
                          cursorColor: colorTextBlack,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Add Discount",
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: variantData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (listContext, index) {
                          return Container(
                            height: MediaQuery.of(context).size.width * 0.14,
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(223, 221, 239, 1),
                                borderRadius: BorderRadius.circular(05)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // padding: const EdgeInsets.all(22),
                                    child: GestureDetector(
                                      child: Container(
                                        // width:
                                        //     MediaQuery.of(context).size.width,
                                        child: Text(
                                          variantData[index]
                                                  .selectData!
                                                  .name
                                                  .isEmpty
                                              ? "Select Variant"
                                              : variantData[index]
                                                  .selectData!
                                                  .name,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: variantData[index]
                                                          .selectData ==
                                                      null
                                                  ? colorTextHint
                                                  : colorTextBlack),
                                        ),
                                      ),
                                      onTap: () {
                                        selectTypeData(TYPE_VERIANT, index,
                                            variantData[index].selectData);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    padding: const EdgeInsets.only(left: 10),
                                    color:
                                        const Color.fromRGBO(213, 210, 234, 1),
                                    height: MediaQuery.of(context).size.width *
                                        0.14,
                                    child: TextField(
                                      maxLines: 1,
                                      controller:
                                          variantData[index].priceController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: const TextStyle(
                                          color: colorBlack,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                      cursorColor: colorTextBlack,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: false),
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "0,00",
                                          hintStyle: TextStyle(
                                              color: colorBlack, fontSize: 16),
                                          border: InputBorder.none),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
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
                            ),
                          );
                        },
                      ),
                      isShowAddMore
                          ? GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(top: 3),
                                child: const Text(
                                  "+Add another variant",
                                  style: TextStyle(
                                      color: colorYellow,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  variantData.add(SelectVariantData(
                                      null, TextEditingController()));
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                            )
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: optionData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (listContext, index) {
                          return Container(
                            height: MediaQuery.of(context).size.width * 0.14,
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(223, 221, 239, 1),
                                borderRadius: BorderRadius.circular(05)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // padding: const EdgeInsets.all(22),
                                    child: GestureDetector(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          optionData[index].selectData == null
                                              ? "Select Option"
                                              : optionData[index]
                                                  .selectData!
                                                  .name,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: optionData[index]
                                                          .selectData ==
                                                      null
                                                  ? colorTextHint
                                                  : colorTextBlack),
                                        ),
                                      ),
                                      onTap: () {
                                        selectTypeData(TYPE_OPTION, index,
                                            optionData[index].selectData);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    padding: const EdgeInsets.only(left: 10),
                                    color:
                                        const Color.fromRGBO(213, 210, 234, 1),
                                    height: MediaQuery.of(context).size.width *
                                        0.14,
                                    child: TextField(
                                      maxLines: 1,
                                      controller:
                                          optionData[index].priceController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: colorTextBlack),
                                      cursorColor: colorTextBlack,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: false),
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "0,00",
                                          hintStyle: TextStyle(
                                              color: colorBlack, fontSize: 16),
                                          border: InputBorder.none),
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
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
                                    )),
                              ],
                            ),
                          );
                        },
                      ),
                      isShowAddMoreOption
                          ? GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(top: 3),
                                child: const Text(
                                  "+Add another option",
                                  style: TextStyle(
                                      color: colorYellow,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  optionData.add(SelectOptionData(
                                      null, TextEditingController()));
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
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
                            child: Text(
                              widget.isEdit ? "Update" : "Add",
                              style: const TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            if (widget.isEdit) {
                              callEditItemApi();
                            } else {
                              callAddItemApi();
                            }
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
                            setState(() {
                              Navigator.of(context).pop(context);
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
          )),
    );
  }

  // void dialogDeleteType(TypeListDataModel model) {
  //   showDialog(
  //     context: context,
  //     builder: (deleteDialogContext) {
  //       return DialogDeleteType(
  //         model: model,
  //         onDialogClose: () {
  //           Navigator.pop(context);
  //           widget.onAddDeleteSuccess();
  //         },
  //       );
  //     },
  //   );
  // }

  void selectTypeData(
      String type, int index, SelectionMenuDataList? selectedData) {
    showDialog(
      context: context,
      builder: (selectDataDialogContext) {
        return DialogMenuDataSelection(
          type: type,
          selectedData: selectedData,
          onSelectData: (SelectionMenuDataList dataModel) {
            setState(() {
              if (type == TYPE_CATEGORY) {
                _categoryData = dataModel;
              } else if (type == TYPE_VERIANT) {
                if (dataModel.id.isEmpty) {
                  isShowAddMore = false;
                } else {
                  isShowAddMore = true;
                }
                variantData[index].selectData = dataModel;
              } else if (type == TYPE_ALLERGY_GROUP) {
                _allergyGroupData = dataModel;
              } else if (type == TYPE_OPTION) {
                if (dataModel.id.isEmpty) {
                  isShowAddMoreOption = false;
                } else {
                  isShowAddMoreOption = true;
                }
                optionData[index].selectData = dataModel;
              }
            });
          },
          optionListSize: optionData.length,
          variantListSize: variantData.length,
        );
      },
    );
  }

  void _pickerFile() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    // if (result == null) return;
    // PlatformFile file = result.files.single;
    // print(file.path);

    // setState(() {
    //   cropperFile = File(file.path!);
    // });
  }
}
