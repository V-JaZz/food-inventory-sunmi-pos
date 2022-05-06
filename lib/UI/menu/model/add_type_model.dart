import 'package:flutter/material.dart';

class AddTypeModel{
  late TextEditingController name;
  late TextEditingController price;
  late TextEditingController description;
  late TextEditingController discount;
  AddTypeModel(this.name, this.price,this.description,this.discount);
}