// ignore_for_file: avoid_print, avoid_unnecessary_containers
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/model/menu_items.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/repository/menu_item_repository.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:image_cropper/image_cropper.dart';

// ignore: must_be_immutable
class DialogMenuItems extends StatefulWidget {
  var isEdit;
  Items? editItem;
  String type;
  VoidCallback onAddDeleteSuccess;

  DialogMenuItems(
      {this.isEdit,
      this.editItem,
      required this.type,
      required this.onAddDeleteSuccess});

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
  SelectionMenuDataList? _categoryData, _allergyGroupData;
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
    optionData = [];
    variantData = [];
    selectedValue =
        widget.type == "Menu" ? 'Online Order Menu' : "Table Order Menu";
    selectedType = widget.type == "Menu" ? "online" : "table";
    if (widget.isEdit) {
      clearImageCache(widget.editItem!.sId!);
      if (widget.editItem!.options!.isEmpty) {
        isShowAddMoreOption = true;
        optionData.add(SelectOptionData(
            SelectionMenuDataList(
                "",
                "Default Option",
                defaultValue(widget.editItem!.price, "0.0"),
                0.0,
                0.0,
                "",
                "",
                false),
            TextEditingController(
                text: defaultValue(widget.editItem!.price, "0.0"))));
      } else {
        for (Options data in widget.editItem!.options!) {
          optionData.add(SelectOptionData(
              SelectionMenuDataList(
                  data.sId!, data.name!, data.price!, 0.0, 0.0, "", "", true),
              TextEditingController(text: data.price)));
        }
      }
      if (widget.editItem!.variants!.isEmpty) {
        isShowAddMore = true;
        for (int i = 0; widget.editItem!.variants!.length < i; i++) {
          variantData.add(SelectVariantData(
              SelectionMenuDataList(
                  "",
                  "Default Option",
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
        for (Variants data in widget.editItem!.variants!) {
          variantData.add(SelectVariantData(
              SelectionMenuDataList(data.sId!, data.name!, data.price!, 0.0,
                  0.0, "", data.variantGroup.toString(), true),
              TextEditingController(text: data.price)));
        }
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
    }
    _itemRepository = MenuItemRepository(context, widget);
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
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 560,
          margin: EdgeInsets.only(top: 20.sp, right: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
              color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEdit ? "Edit Item" : "Add New Item",
                      style: const TextStyle(
                          color: colorTextBlack,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
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
                                    height: 60,
                                    width: 60,
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
                                        width: 60,
                                        height: 60,
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
                                          height: 60,
                                          width: 60,
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
                                          children: [
                                            const Text(
                                              "Add image",
                                              style: TextStyle(
                                                  color: colorBlack,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            const Icon(
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
                                      height: 60,
                                      width: 60,
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
                                      children: [
                                        const Text(
                                          "Add image",
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        const Icon(
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
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Menu Type",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(08),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBG,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
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
                    Text(
                      widget.isEdit ? "Enter Item" : "Enter New Item",
                      style:
                          const TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBG,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
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
                    const Text(
                      "Select Category",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBG,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            _categoryData == null
                                ? "Select Category"
                                : _categoryData!.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: _categoryData == null
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
                    const Text(
                      "Select Allergy Group",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBG,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            _allergyGroupData == null
                                ? "Select Allergy Group"
                                : _allergyGroupData!.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
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
                    const Text(
                      "Add Description",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBG,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
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
                    const Text(
                      "Add Discount",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBG,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
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
                    const Text(
                      "Select Variant",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: variantData.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (listContext, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 3.sp, bottom: 5.sp),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: colorFieldBorder, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  child: GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        variantData[index].selectData == null
                                            ? "Select Variant"
                                            : variantData[index]
                                                .selectData!
                                                .name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                variantData[index].selectData ==
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
                                  width: 0.07,
                                  padding: const EdgeInsets.all(0.037),
                                  color: colorFieldBG,
                                  child: TextField(
                                    maxLines: 1,
                                    controller:
                                        variantData[index].priceController,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                        fontSize: 16,
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
                                  width: 70,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(25),
                                  decoration:
                                      const BoxDecoration(color: colorYellow),
                                  child: const Text("€",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ))),
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
                    const Text(
                      "Select Option",
                      style: TextStyle(color: colorTextBlack, fontSize: 16),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: optionData.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (listContext, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 3, bottom: 5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: colorFieldBorder, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  child: GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        optionData[index].selectData == null
                                            ? "Select Option"
                                            : optionData[index]
                                                .selectData!
                                                .name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                optionData[index].selectData ==
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
                                  width: 0.07,
                                  padding: const EdgeInsets.all(0.037),
                                  color: colorFieldBG,
                                  child: TextField(
                                    maxLines: 1,
                                    controller:
                                        optionData[index].priceController,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                        fontSize: 16,
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
                                  width: 70,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(25),
                                  decoration:
                                      const BoxDecoration(color: colorYellow),
                                  child: const Text("€",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ))),
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
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: colorYellow,
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            widget.isEdit ? "Update" : "Add",
                            style: const TextStyle(
                                color: colorTextWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
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
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: colorGrey,
                              borderRadius: BorderRadius.circular(30)),
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
        ));
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
                    child: Text(
                      'Take a picture',
                      style: TextStyle(color: colorTextBlack, fontSize: 22.sp),
                    ),
                    onTap: () {
                      setState(() async {
                        Navigator.pop(_context);
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text(
                      'Select from gallery',
                      style: TextStyle(color: colorTextBlack, fontSize: 22.sp),
                    ),
                    onTap: () {
                      _pickerFile();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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

  Future<void> _cropImage(path) async {
    print(path);
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
}

class SelectOptionData {
  SelectionMenuDataList? selectData;
  late TextEditingController priceController;
  SelectOptionData(this.selectData, this.priceController);
}

class SelectVariantData {
  SelectionMenuDataList? selectData;
  late TextEditingController priceController;
  SelectVariantData(this.selectData, this.priceController);
}
