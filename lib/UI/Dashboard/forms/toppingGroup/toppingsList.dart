// ignore: file_names
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/forms/Toppings/model/toppings_list_response_model.dart';
import 'package:food_inventory/UI/dashboard/forms/toppingGroup/repository/topping_groups_repository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
// ignore: library_prefixes
import 'package:food_inventory/constant/switch.dart' as SW;

// ignore: must_be_immutable
class ToppingListPage extends StatefulWidget {
  String name;
  String id;
  List<String> ids = [];
  // ignore: prefer_typing_uninitialized_variables
  var type;
  VoidCallback onDialogClose;

  ToppingListPage(
      {Key? key,
      required this.name,
      required this.id,
      required this.ids,
      this.type,
      required this.onDialogClose})
      : super(key: key);

  @override
  _ToppingListPageState createState() => _ToppingListPageState();
}

class _ToppingListPageState extends State<ToppingListPage> {
  List<SelectionToppingListData> selectionData = [];
  late ToppingGroupsRepository _toppingGroupsRepository;
  bool isDataLoad = false;

  @override
  void initState() {
    super.initState();
    selectionData = [];
    _toppingGroupsRepository = ToppingGroupsRepository(context, widget);
    getToppings();
  }

  callAddToppingGroupApi() async {
    _toppingGroupsRepository.addToppingGroup(widget.name, selectionData);
  }

  callEditToppingGroupApi() async {
    _toppingGroupsRepository.editToppingGroup(
        widget.name, widget.id, selectionData);
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
              bool isSelected = false;
              if (widget.type == "Edit") {
                for (String selectedId in widget.ids) {
                  if (data.sId == selectedId) {
                    if (kDebugMode) {
                      print("DATA IS: " + isSelected.toString());
                    }
                    isSelected = true;
                    break;
                  }
                }
              }
              selectionData.add(SelectionToppingListData(
                  data.sId!, data.name!, data.price!, isSelected));
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

  int selected = 0;
  bool visible = true;
  bool item = true;
  bool category = true;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3.0,
        sigmaY: 3.0,
      ),
      child: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
        child: Dialog(
            alignment: Alignment.topCenter,
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: isDataLoad
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color: colorGreen,
                    ),
                  )
                : Container(
                    alignment: Alignment.topCenter,

                    // color: colorTextWhite,
                    decoration: BoxDecoration(
                        color: colorTextWhite,
                        borderRadius: BorderRadius.circular(13)),
                    margin: const EdgeInsets.only(top: 200),
                    height: MediaQuery.of(context).size.height * 0.37,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          decoration: const BoxDecoration(
                              // color: colorGreen,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  widget.name,
                                  style: const TextStyle(
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
                          height: MediaQuery.of(context).size.height * 0.24,
                          child: ListView.builder(
                            itemCount: selectionData.length,
                            shrinkWrap: true,
                            itemBuilder: (listContext, index) {
                              return Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: const EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? const Color.fromRGBO(228, 225, 246, 1)
                                            : colorTextWhite),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.54,
                                          child: Text(
                                            selectionData[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                        SW.Switch(
                                            value:
                                                selectionData[index].isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                selectionData[index]
                                                    .isSelected = value;
                                              });
                                            },
                                            // activeColor: colorGreen,
                                            inactiveTrackColor:
                                                colorButtonYellow,
                                            activeTrackColor: colorGreen,
                                            thumbColor: MaterialStateProperty
                                                .all<Color>(Colors.white))
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: 20, right: 22, left: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          // width: 480,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 8),
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
                                    if (widget.type == "Edit") {
                                      callEditToppingGroupApi();
                                    } else {
                                      callAddToppingGroupApi();
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                        color: colorGrey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }
}

class SelectionToppingListData {
  late String id, name, price;
  late bool isSelected;

  SelectionToppingListData(this.id, this.name, this.price, this.isSelected);
}
