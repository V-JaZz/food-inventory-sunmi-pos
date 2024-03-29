// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_inventory/UI/dashboard/forms/Varient/model/veriant_list.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'edit_varient.dart';

// ignore: must_be_immutable
class VarientList extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var type;
  VoidCallback onDialogClose;

  VarientList({Key? key, this.type, required this.onDialogClose})
      : super(key: key);

  @override
  _VarientListState createState() => _VarientListState();
}

class _VarientListState extends State<VarientList> {
  List<TypeListDataModel> dataList = [];
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
                  TYPE_VERIANT,
                  data.sId!,
                  0,
                  data.name!,
                  data.price!,
                  "",
                  "",
                  [],
                  data.variantGroups!.sId.toString(),
                  data.variantGroups!.name.toString(),
                  "",
                  "",
                  0));
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getVarient();
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
            insetPadding: EdgeInsets.all(20.0),
            elevation: 0,
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            child: isDataLoad
                ? Center(
                    child: CircularProgressIndicator(
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
                              EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: Icon(Icons.arrow_back,
                                      color: colorButtonYellow)),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  "My Varient",
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
                          margin: EdgeInsets.only(bottom: 05),
                          height: MediaQuery.of(context).size.height * 0.43,
                          child: ListView.builder(
                            itemCount: dataList.length,
                            shrinkWrap: true,
                            itemBuilder: (listContext, index) {
                              return Container(
                                key: ValueKey(index),
                                color: index % 2 == 0
                                    ? const Color.fromRGBO(228, 225, 246, 1)
                                    : colorTextWhite,
                                child: Slidable(
                                  closeOnScroll: true,
                                  groupTag: dataList[index].id,
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      Spacer(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: SlidableAction(
                                          onPressed: (context) {
                                            dialogDeleteType(dataList[index]);
                                          },
                                          backgroundColor: colorButtonYellow,
                                          foregroundColor: colorTextWhite,
                                          icon: Icons.delete,
                                          // label: 'Delete',
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: SlidableAction(
                                          onPressed: (context) {
                                            Navigator.of(context).pop();
                                            editVarient(
                                              dataList[index].toppingName,
                                              dataList[index].toppingId,
                                              dataList[index].id.toString(),
                                              dataList[index].name,
                                            );
                                          },
                                          backgroundColor: colorTextBlack,
                                          foregroundColor: colorTextWhite,
                                          icon: Icons.edit,
                                          // label: 'Share',
                                        ),
                                      ),
                                    ],
                                  ),
                                  key: ValueKey(index),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? Color.fromRGBO(
                                                    228, 225, 246, 1)
                                                : colorTextWhite),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                dataList[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: colorTextBlack,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
            getVarient();
          },
        );
      },
    );
  }

  void editVarient(
    String varientName,
    String varientId,
    String id,
    String name,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return EditVarient(
          onDialogClose: () {
            setState(() {
              dataList = [];
            });
            getVarient();
          },
          id: id,
          name: name,
          varientId: varientId,
          varientName: varientName,
        );
      },
    );
  }
}
