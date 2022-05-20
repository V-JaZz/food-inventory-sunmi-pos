import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';

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
