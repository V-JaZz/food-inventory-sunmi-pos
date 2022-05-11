import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/model/topping_group_list_response_model.dart';
import 'package:food_inventory/UI/menu/model/toppings_list_response_model.dart';
import 'package:food_inventory/UI/menu/model/veriant_group_list_model.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'model/allergy_group_list_response.dart';
import 'model/allergy_list_response.dart';
import 'model/category_list_response_model.dart';
import 'model/option_list_response_model.dart';
import 'model/veriant_list.dart';

class DialogTypeListView extends StatefulWidget {
  var type;
  VoidCallback onDialogClose;

  DialogTypeListView({this.type, required this.onDialogClose});

  @override
  _DialogTypeListViewState createState() => _DialogTypeListViewState();
}

class _DialogTypeListViewState extends State<DialogTypeListView> {
  bool isDataLoad = false;

  List<TypeListDataModel> dataList = [];
  List<CategoryListData> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = [];
    if (widget.type == TYPE_CATEGORY) {
      getCategories();
    } else if (widget.type == TYPE_OPTION) {
      getOptions();
    } else if (widget.type == TYPE_TOPPINGS) {
      getToppings();
    } else if (widget.type == TYPE_ALLERGY) {
      getAllergy();
    } else if (widget.type == TYPE_ALLERGY_GROUP) {
      getAllergyGroup();
    } else if (widget.type == TYPE_VERIANT) {
      getVarient();
    } else if (widget.type == TYPE_VARIANT_GROUP) {
      getVarientGroup();
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
              List<String> selectedIds = [];
              for (VariantsGroup subData in data.variants!) {
                selectedIds.add(subData.sId!);
              }
              dataList.add(TypeListDataModel(widget.type, data.sId!, 0,
                  data.name!, "", "", "", selectedIds, "", "", "", "", 0));
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
              if (data.description != null) {
                dataList.add(TypeListDataModel(
                    widget.type,
                    data.sId!,
                    data.position!,
                    data.name!,
                    "",
                    data.description!,
                    data.imageName!,
                    [],
                    "",
                    "",
                    "",
                    "",
                    data.discount ?? 0));
              } else {
                dataList.add(TypeListDataModel(
                    widget.type,
                    data.sId!,
                    data.position!,
                    data.name!,
                    "",
                    "",
                    "",
                    [],
                    "",
                    "",
                    "",
                    "",
                    data.discount ?? 0));
              }
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
              dataList.add(TypeListDataModel(
                  widget.type,
                  data.sId!,
                  0,
                  data.name!,
                  "",
                  "",
                  "",
                  [],
                  data.toppingGroups!.sId.toString(),
                  data.toppingGroups!.name.toString(),
                  data.minToppings.toString(),
                  data.maxToppings.toString(),
                  0));
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
              dataList.add(TypeListDataModel(
                  widget.type,
                  data.sId!,
                  0,
                  data.name!,
                  data.price!,
                  "",
                  "",
                  [],
                  "",
                  data.variantGroups!.name.toString(),
                  "",
                  "",
                  0));
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

  getToppings() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getToppings, token);
        ToppingsListResponseModel model = ToppingsListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (ToppingsListData data in model.data!) {
              dataList.add(TypeListDataModel(widget.type, data.sId!, 0,
                  data.name!, data.price!, "", "", [], "", "", "", "", 0));
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
              List<String> selectedIds = [];
              for (ToppingsData subData in data.toppings!) {
                selectedIds.add(subData.sId!);
              }
              dataList.add(TypeListDataModel(
                  widget.type,
                  data.sId!,
                  0,
                  data.name!,
                  data.price!,
                  "",
                  "",
                  selectedIds,
                  "",
                  "",
                  "",
                  "",
                  0));
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

  getAllergy() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getAllergies, token);
        AllergyListResponseModel model = AllergyListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (AllergyListData data in model.data!) {
              dataList.add(TypeListDataModel(
                  widget.type,
                  data.sId!,
                  0,
                  data.name!,
                  "",
                  data.description!,
                  "",
                  [],
                  "",
                  "",
                  "",
                  "",
                  0));
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
              dataList.add(TypeListDataModel(
                  widget.type,
                  data.sId!,
                  0,
                  data.name!,
                  data.price!,
                  "",
                  "",
                  selectedIds,
                  "",
                  "",
                  "",
                  "",
                  0));
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

  ApiBaseHelper _helper = ApiBaseHelper();

//   // late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  updateCategoryPosition(
      currentPosition, targetPosition, currentCategory, targetCategory) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      var body = jsonEncode({
        'currentPosition': currentPosition.toString().trim(),
        'targetPosition': targetPosition.toString().trim(),
        'currentCategory': currentCategory.toString().trim(),
        'targetCategory': targetCategory.toString().trim()
      });

      if (body.isNotEmpty) {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        try {
          final response = await _helper.post(
              ApiBaseHelper.updateCategoryPosition, body, token);

          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(context, response));
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            Navigator.pop(context);
          } else {
            showMessage(model.message!, context);
            getCategories();
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 560,
          margin: EdgeInsets.only(top: 10, right: 20),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
              color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
          child: ListView(
            shrinkWrap: true,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      icBackArrow,
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "My ${widget.type}",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              isDataLoad
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        color: colorYellow,
                      ),
                    )
                  : Container(
                      height: 190,
                      child: ReorderableListView.builder(
                          itemCount: dataList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Container(
                              color:
                                  index % 2 == 0 ? colorTextWhite : colorBorder,
                              key: ValueKey(dataList[index].id),
                              child: Column(
                                key: ValueKey(dataList[index].id),
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        widget.type == TYPE_TOPPINGS
                                            ? Expanded(
                                                child: RichText(
                                                    text: TextSpan(
                                                        text: dataList[index]
                                                            .name,
                                                        style: TextStyle(
                                                            color:
                                                                colorTextBlack,
                                                            fontSize: 16),
                                                        children: [
                                                    TextSpan(
                                                        text:
                                                            " (€${dataList[index].price})",
                                                        style: TextStyle(
                                                            color:
                                                                colorLightRed,
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
                                        GestureDetector(
                                          child: Text("Edit",
                                              style: TextStyle(
                                                  color: colorYellow,
                                                  fontSize: 16)),
                                          onTap: () {
                                            Navigator.pop(context);
                                            widget.onDialogClose();
                                            // if (widget.type ==
                                            //     TYPE_GROUP_TOPPINGS) {
                                            //   dialogToppingSelection(
                                            //       dataList[index],
                                            //       true,
                                            //       context);
                                            // } else if (widget.type ==
                                            //     TYPE_ALLERGY_GROUP) {
                                            //   dialogAllergySelection(
                                            //       dataList[index],
                                            //       true,
                                            //       context);
                                            // } else if (widget.type ==
                                            //     TYPE_VARIANT_GROUP) {
                                            //   dialogVariantsSelection(
                                            //       dataList[index],
                                            //       true,
                                            //       context);
                                            // } else {
                                            //   dialogEditType(
                                            //       dataList[index]);
                                            // }
                                          },
                                          behavior: HitTestBehavior.opaque,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        GestureDetector(
                                          child: SvgPicture.asset(
                                            icDelete,
                                            width: 18,
                                            height: 18,
                                          ),
                                          onTap: () {
                                            dialogDeleteType(dataList[index]);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   height: 1,
                                  //   decoration: BoxDecoration(
                                  //       color: colorDividerGreen),
                                  // )
                                ],
                              ),
                            );
                          },
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              var oldPosition =
                                  dataList.elementAt(oldIndex).pos;
                              var newPosition =
                                  dataList.elementAt(newIndex).pos;
                              var currentItemId =
                                  dataList.elementAt(oldIndex).id;
                              var targetItemId =
                                  dataList.elementAt(newIndex).id;
                              updateCategoryPosition(oldPosition, newPosition,
                                  currentItemId, targetItemId);
                              print(currentItemId.toString() + 'OLD ITEM ID');
                              print(targetItemId.toString() + 'NEW ITEM ID');
                              print(oldPosition.toString() + 'OLD POSITION ID');
                              print(newPosition.toString() + 'NEW POSITION ID');
                              print(oldIndex.toString() + 'OLD INDEX');
                              print(newIndex.toString() + 'NEW INDEX');
                            });
                          }),
                    ),
              // ListView.builder(
              //     itemCount: dataList.length,
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemBuilder: (listContext, index) {
              //       return Column(
              //         children: [
              //           Container(
              //             padding:
              //                 EdgeInsets.symmetric(vertical: 15),
              //             child: Row(
              //               crossAxisAlignment:
              //                   CrossAxisAlignment.center,
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: [
              //                 widget.type == TYPE_TOPPINGS
              //                     ? Expanded(
              //                         child: RichText(
              //                             text: TextSpan(
              //                                 text:
              //                                     dataList[index].name,
              //                                 style: TextStyle(
              //                                     color: colorTextBlack,
              //                                     fontSize: 16),
              //                                 children: [
              //                             TextSpan(
              //                                 text:
              //                                     " (€${dataList[index].price})",
              //                                 style: TextStyle(
              //                                     color: colorLightRed,
              //                                     fontSize: 16)),
              //                           ])))
              //                     : Expanded(
              //                         child: Text(
              //                         dataList[index].name,
              //                         style: TextStyle(
              //                             color: colorTextBlack,
              //                             fontSize: 16),
              //                       )),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 GestureDetector(
              //                   child: Text("Edit",
              //                       style: TextStyle(
              //                           color: colorLightRed,
              //                           fontSize: 16)),
              //                   onTap: () {
              //                     Navigator.pop(context);
              //                     widget.onDialogClose();
              //                     if (widget.type ==
              //                         TYPE_GROUP_TOPPINGS) {
              //                       dialogToppingSelection(
              //                           dataList[index], true, context);
              //                     } else {
              //                       dialogEditType(dataList[index]);
              //                     }
              //                   },
              //                   behavior: HitTestBehavior.opaque,
              //                 ),
              //                 SizedBox(
              //                   width: 16,
              //                 ),
              //                 GestureDetector(
              //                   child: SvgPicture.asset(
              //                     icDelete,
              //                     width: 18,
              //                     height: 18,
              //                   ),
              //                   onTap: () {
              //                     dialogDeleteType(dataList[index]);
              //                   },
              //                 )
              //               ],
              //             ),
              //           ),
              //           Container(
              //             height: 1,
              //             decoration:
              //                 BoxDecoration(color: colorDividerGreen),
              //           )
              //         ],
              //       );
              //     },
              //   ),
              // GestureDetector(
              //   child: Container(
              //     margin: EdgeInsets.only(top: 20),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         SvgPicture.asset(
              //           icBackArrow,
              //           width: 40,
              //           height: 40,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           "Back",
              //           style: TextStyle(
              //               color: colorTextBlack,
              //               fontSize: 18,
              //               fontWeight: FontWeight.w500),
              //         )
              //       ],
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // )
            ],
          ),
        ));
  }

  // void dialogVariantsSelection(
  //     TypeListDataModel editData, bool isEdit, BuildContext mainContext) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogListContext) {
  //       return DialogVariantSelection(
  //         isEdit: isEdit,
  //         onDialogClose: () {
  //           Navigator.pop(context);
  //           widget.onDialogClose();
  //         },
  //         addGroupData: null,
  //         editGroup: editData,
  //       );
  //     },
  //   );
  // }

  // void dialogToppingSelection(
  //     TypeListDataModel editData, bool isEdit, BuildContext mainContext) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogListContext) {
  //       return DialogToppingSelection(
  //         isEdit: isEdit,
  //         onDialogClose: () {
  //           Navigator.pop(context);
  //           widget.onDialogClose();
  //         },
  //         addGroupData: null,
  //         editGroup: editData,
  //       );
  //     },
  //   );
  // }

  // void dialogAllergySelection(
  //     TypeListDataModel editData, bool isEdit, BuildContext mainContext) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogListContext) {
  //       return DialogAllergySelection(
  //         isEdit: isEdit,
  //         onDialogClose: () {
  //           Navigator.pop(context);
  //           widget.onDialogClose();
  //         },
  //         addGroupData: null,
  //         editGroup: editData,
  //       );
  //     },
  //   );
  // }

  // void dialogEditType(TypeListDataModel model) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (editDialogContext) {
  //       return DialogEditType(model);
  //     },
  //   );
  // }

  void dialogDeleteType(TypeListDataModel model) {
    showDialog(
      context: context,
      builder: (deleteDialogContext) {
        return DialogDeleteType(
          model: model,
          onDialogClose: () {
            setState(() {
              dataList = [];
            });
            if (widget.type == TYPE_CATEGORY) {
              getCategories();
            } else if (widget.type == TYPE_OPTION) {
              getOptions();
            } else if (widget.type == TYPE_TOPPINGS) {
              getToppings();
            } else if (widget.type == TYPE_ALLERGY) {
              getAllergy();
            } else if (widget.type == TYPE_ALLERGY_GROUP) {
              getAllergyGroup();
            } else if (widget.type == TYPE_VARIANT_GROUP) {
              getVarientGroup();
            } else if (widget.type == TYPE_VERIANT) {
              getVarient();
            } else {
              getToppingGroup();
              // Navigator.pop(context);
              // widget.onDialogClose();
            }
          },
        );
      },
    );
  }
}

class TypeListDataModel {
  late String type, id, name, price, description, imageType;
  late List<String> selectedData;
  late String toppingId, toppingName, maxTopping, minTopping;
  int pos, discount;

  TypeListDataModel(
      this.type,
      this.id,
      this.pos,
      this.name,
      this.price,
      this.description,
      this.imageType,
      this.selectedData,
      this.toppingId,
      this.toppingName,
      this.maxTopping,
      this.minTopping,
      this.discount);
}
