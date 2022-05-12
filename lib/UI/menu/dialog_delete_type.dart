import 'package:flutter/material.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/UI/menu/repository/delete_data_repository.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';

class DialogDeleteType extends StatefulWidget {
  // var type, name;
  TypeListDataModel model;
  VoidCallback onDialogClose;

  DialogDeleteType({required this.model, required this.onDialogClose});

  @override
  _DialogDeleteTypeState createState() => _DialogDeleteTypeState();
}

class _DialogDeleteTypeState extends State<DialogDeleteType> {
  late DeleteDataRepository _deleteDataRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deleteDataRepository =
        new DeleteDataRepository(context, widget, widget.model);
  }

  callDeleteType() async {
    if (widget.model.type == TYPE_CATEGORY) {
      _deleteDataRepository.deleteCategoryData();
    } else if (widget.model.type == TYPE_OPTION) {
      _deleteDataRepository.deleteOptionData();
    } else if (widget.model.type == TYPE_TOPPINGS) {
      _deleteDataRepository.deleteToppingData();
    } else if (widget.model.type == TYPE_GROUP_TOPPINGS) {
      _deleteDataRepository.deleteToppingGroupData();
    } else if (widget.model.type == TYPE_MENU_ITEM) {
      _deleteDataRepository.deleteMenuItemData();
    } else if (widget.model.type == TYPE_ALLERGY) {
      _deleteDataRepository.deleteAllergyData();
    } else if (widget.model.type == TYPE_ALLERGY_GROUP) {
      _deleteDataRepository.deleteAllergyGroupData();
    } else if (widget.model.type == TYPE_VARIANT_GROUP) {
      _deleteDataRepository.deleteVariantGroupData();
    } else if (widget.model.type == TYPE_VERIANT) {
      _deleteDataRepository.deleteVariantData();
    } else {
      Navigator.pop(context);
      widget.onDialogClose();
    }
    // Navigator.pop(context);
    // widget.onDialogClose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          // width: Media/,
          // margin: EdgeInsets.only(top: 20, right: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
              color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                widget.model.name,
                style: const TextStyle(
                    color: colorYellow,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Are you sure Delete this ${widget.model.type}?",
                style: const TextStyle(
                    color: colorTextBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: colorYellow,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text(
                            "Delete",
                            style: const TextStyle(
                                color: colorTextWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                        onTap: () {
                          callDeleteType();
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
        ));
  }
}
