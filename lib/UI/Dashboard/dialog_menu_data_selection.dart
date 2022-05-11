import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/Dashboard/forms/AllergyGroup/model/allergy_group_list_response.dart';
import 'package:food_inventory/UI/dashboard/forms/Category/model/category_list_response_model.dart';
import 'package:food_inventory/UI/dashboard/forms/Option/model/option_list_response_model.dart';
import 'package:food_inventory/UI/dashboard/forms/Varient/model/veriant_list.dart';
import 'package:food_inventory/UI/dashboard/forms/VarientGroup/model/veriant_group_list_model.dart';
import 'package:food_inventory/UI/dashboard/forms/toppingGroup/model/topping_group_list_response_model.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

typedef SelectDataFunc = void Function(SelectionMenuDataList);

class DialogMenuDataSelection extends StatefulWidget {
  late String type;
  SelectionMenuDataList? selectedData;
  SelectDataFunc onSelectData;
  late int optionListSize;
  late int variantListSize;

  DialogMenuDataSelection(
      {required this.type,
      this.selectedData,
      required this.onSelectData,
      required this.optionListSize,
      required this.variantListSize});

  @override
  _DialogMenuDataSelectionState createState() =>
      _DialogMenuDataSelectionState();
}

class _DialogMenuDataSelectionState extends State<DialogMenuDataSelection> {
  bool isDataLoad = false;
  List<SelectionMenuDataList> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = [];
    if (widget.type == TYPE_CATEGORY) {
      getCategories();
    } else if (widget.type == TYPE_OPTION) {
      getOptions();
    } else if (widget.type == TYPE_VERIANT) {
      getVarient();
    } else if (widget.type == TYPE_VARIANT_GROUP) {
      getVarientGroup();
    } else if (widget.type == TYPE_ALLERGY_GROUP) {
      getAllergyGroup();
    } else {
      getToppingGroup();
    }
  }

  getVarientGroup() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getVariantGroups, token);
        VarientGroupListModel model = VarientGroupListModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (VarientGroupList data in model.data!) {
              dataList.add(SelectionMenuDataList(
                  data.sId!,
                  data.name!,
                  "",
                  0.0,
                  0.0,
                  "",
                  // data.variantGroups!.sId.toString(),
                  "",
                  widget.selectedData == null
                      ? false
                      : widget.selectedData!.id == data.sId));
              // List<String> selectedIds = [];
              // for (Variants subData in data.variants!) {
              //   selectedIds.add(subData.sId!);
              // }

            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  getVarient() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getVariantsList, token);
        VarantListData model = VarantListData.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (VariantsList data in model.data!) {
              // List<String> selectedIds = [];
              // for (Variants subData in data.variants!) {
              //   selectedIds.add(subData.sId!);
              // }
              dataList.add(SelectionMenuDataList(
                  data.sId!,
                  data.name!,
                  data.price!,
                  0.0,
                  0.0,
                  data.variantGroups!.name!,
                  data.variantGroups!.sId.toString(),
                  widget.selectedData == null
                      ? false
                      : widget.selectedData!.id == data.sId));
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  getAllergyGroup() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getAllergiesGroup, token);
        AllergyGroupListResponseModel model =
            AllergyGroupListResponseModel.fromJson(
                ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (AllergyGroupListData data in model.data!) {
              List<String> selectedIds = [];
              for (AllergyData subData in data.allergies!) {
                selectedIds.add(subData.sId!);
              }
              dataList.add(SelectionMenuDataList(
                  data.sId!,
                  data.name!,
                  "",
                  0.0,
                  0.0,
                  "",
                  "",
                  widget.selectedData == null
                      ? false
                      : widget.selectedData!.id == data.sId));
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  getCategories() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getCategories, token);
        CategoryListResponseModel model = CategoryListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (CategoryListData data in model.data!) {
              dataList.add(SelectionMenuDataList(
                  data.sId!,
                  data.name!,
                  "",
                  0.0,
                  0.0,
                  "",
                  "",
                  widget.selectedData == null
                      ? false
                      : widget.selectedData!.id == data.sId));
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  getOptions() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getOptions, token);
        OptionListResponseModel model = OptionListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (OptionListData data in model.data!) {
              print("NAme option : " + data.name!);
              dataList.add(SelectionMenuDataList(
                  data.sId.toString(),
                  data.name.toString(),
                  "",
                  data.minToppings!.toDouble(),
                  data.maxToppings!.toDouble(),
                  data.toppingGroups!.name.toString(),
                  data.toppingGroups!.sId.toString(),
                  widget.selectedData == null
                      ? false
                      : widget.selectedData!.id == data.sId));
            }
          }
        }
      } catch (e) {
        print(e.toString());
        if (mounted) {
          setState(() {
            isDataLoad = false;
          });
        }
      }
    });
  }

  getToppingGroup() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getToppingGroups, token);
        ToppingsGroupListResponseModel model =
            ToppingsGroupListResponseModel.fromJson(
                ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (ToppingsGroupListData data in model.data!) {
              dataList.add(SelectionMenuDataList(
                  data.sId!,
                  data.name!,
                  "",
                  0.0,
                  0.0,
                  "",
                  "",
                  widget.selectedData == null
                      ? false
                      : widget.selectedData!.id == data.sId));
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            // width: Media,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),

            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select ${widget.type}",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    widget.type == TYPE_CATEGORY
                        ? Container()
                        : widget.type == TYPE_GROUP_TOPPINGS
                            ? getDefaultButton()
                            : widget.type == TYPE_OPTION &&
                                    widget.optionListSize > 1
                                ? Container()
                                : widget.type == TYPE_VERIANT &&
                                        widget.variantListSize > 1
                                    ? Container()
                                    : getDefaultButton()
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                isDataLoad
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          color: colorGreen,
                        ),
                      )
                    : ListView.builder(
                        itemCount: dataList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (listContext, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      widget.type == TYPE_TOPPINGS
                                          ? Expanded(
                                              child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          dataList[index].name,
                                                      style: TextStyle(
                                                          color: colorTextBlack,
                                                          fontSize: 16),
                                                      children: [
                                                  TextSpan(
                                                      text:
                                                          " (€${dataList[index].price})",
                                                      style: TextStyle(
                                                          color: colorLightRed,
                                                          fontSize: 16)),
                                                ])))
                                          : Expanded(
                                              child: Text(
                                              dataList[index].name,
                                              style: TextStyle(
                                                  color: colorTextBlack,
                                                  fontSize: 16),
                                            )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.asset(
                                        dataList[index].isSelected
                                            ? icRadioCheck
                                            : icRadioUncheck,
                                        width: 18,
                                        height: 18,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  widget.onSelectData(dataList[index]);
                                  Navigator.pop(context);
                                },
                              ),
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: colorDividerGreen),
                              )
                            ],
                          );
                        },
                      ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          icBackArrow,
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )),
    );
  }

  Widget getDefaultButton() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: colorButtonYellow,
            borderRadius: BorderRadius.circular(30.0)),
        child: Text("Default",
            style: TextStyle(
                color: colorTextWhite,
                fontWeight: FontWeight.w500,
                fontSize: 13)),
      ),
      onTap: () {
        //TODO:  Delete Item
        widget.onSelectData(SelectionMenuDataList(
            "", "Default ${widget.type}", "", 0.0, 0.0, "", "", false));
        Navigator.pop(context);
      },
      behavior: HitTestBehavior.opaque,
    );
  }
}

class SelectionMenuDataList {
  late String id, name, price, selectedToppingName, selectedToppingId;
  late bool isSelected;
  late double minTopping, maxTopping;
  SelectionMenuDataList(
      this.id,
      this.name,
      this.price,
      this.minTopping,
      this.maxTopping,
      this.selectedToppingName,
      this.selectedToppingId,
      this.isSelected);
}
