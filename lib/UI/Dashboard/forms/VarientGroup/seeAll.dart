// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unnecessary_const, unused_local_variable

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_inventory/UI/Dashboard/forms/VarientGroup/varientList.dart';
import 'package:food_inventory/UI/dashboard/forms/VarientGroup/model/veriant_group_list_model.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

// ignore: must_be_immutable
class VarientListGroup extends StatefulWidget {
  var type;
  VoidCallback onDialogClose;

  VarientListGroup({Key? key, this.type, required this.onDialogClose})
      : super(key: key);

  @override
  _VarientListGroupState createState() => _VarientListGroupState();
}

class _VarientListGroupState extends State<VarientListGroup> {
  List<TypeListDataModel> dataList = [];
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

  @override
  void initState() {
    super.initState();
    getVarientGroup();
  }

  bool isDataLoad = false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3.0,
        sigmaY: 3.0,
      ),
      child: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
        child: Dialog(
            insetPadding: const EdgeInsets.all(20.0),
            elevation: 0,
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            child: isDataLoad
                ? const Center(
                    child: const CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color: colorGreen,
                    ),
                  )
                : Container(
                    alignment: Alignment.center,

                    // color: colorTextWhite,
                    decoration: BoxDecoration(
                        color: colorTextWhite,
                        borderRadius: BorderRadius.circular(13)),
                    // margin: EdgeInsets.only(top: 200),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: const Icon(Icons.arrow_back,
                                      color: colorButtonYellow)),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                child: const Text(
                                  "My Allergy Group",
                                  style: TextStyle(
                                      color: colorTextBlack,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 05),
                          height: MediaQuery.of(context).size.height * 0.43,
                          child: ListView.builder(
                            itemCount: dataList.length,
                            shrinkWrap: true,
                            itemBuilder: (listContext, index) {
                              final item = dataList[index];

                              return Container(
                                key: ValueKey(index),
                                color: index % 2 == 0
                                    ? const Color.fromRGBO(228, 225, 246, 1)
                                    : colorTextWhite,
                                child: Slidable(
                                  useTextDirection: true,
                                  key: ValueKey(dataList[index].id),
                                  closeOnScroll: true,
                                  endActionPane: ActionPane(
                                    extentRatio: 0.35,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          dialogDeleteType(dataList[index]);
                                        },
                                        backgroundColor: colorButtonYellow,
                                        foregroundColor: colorTextWhite,
                                        icon: Icons.delete,
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          Navigator.of(context).pop();
                                          editAllergys(
                                              dataList[index].id,
                                              dataList[index].name.toString(),
                                              dataList[index].price,
                                              dataList[index].selectedData);
                                        },
                                        backgroundColor: colorTextBlack,
                                        foregroundColor: colorTextWhite,
                                        icon: Icons.edit,
                                        // label: 'Share',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? const Color.fromRGBO(228, 225, 246, 1)
                                            : colorTextWhite),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            dataList[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }

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
            getVarientGroup();
          },
        );
      },
    );
  }

  void editAllergys(
    String id,
    String name,
    String price,
    List<String> ids,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VarientListPage(
          onDialogClose: () {
            setState(() {
              dataList = [];
            });
            getVarientGroup();
          },
          id: id,
          name: name,
          type: "Edit",
          ids: ids,
        );
      },
    );
  }
}
