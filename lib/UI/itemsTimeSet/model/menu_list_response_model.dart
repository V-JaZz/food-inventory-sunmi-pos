class MenuListResponseModel {
  bool? success;
  List<MenuItemData>? data;

  MenuListResponseModel({this.success, this.data});

  MenuListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MenuItemData>[];
      json['data'].forEach((v) {
        data!.add(MenuItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItemData {
  String? sId;
  List<OptionsData>? options;
  String? name;
  String? price;
  List<Toppings>? toppings;
  String? description;

  CategoryData? category;
  ToppingGroupData? toppingGroups;
  bool? checkbox;

  // String? categoryName;
  // String? toppingGrpName;

  MenuItemData(
      {this.sId,
      this.options,
      this.name,
      this.price,
      this.toppings,
        this.description,
      // this.categoryName,
      // this.toppingGrpName
      this.category,
      this.toppingGroups,
        this.checkbox});

  MenuItemData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['options'] != null) {
      options = <OptionsData>[];
      json['options'].forEach((v) {
        options!.add(OptionsData.fromJson(v));
      });
    }
    name = json['name'];
    price = json['price'].toString();
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(Toppings.fromJson(v));
      });
    }
    description=json['description'];
    // categoryName = json['category'];
    // toppingGrpName = json['toppingGroups'];

    category = json['category'] != null
        ? CategoryData.fromJson(json['category'])
        : null;
    toppingGroups = json['toppingGroups'] != null
        ? ToppingGroupData.fromJson(json['toppingGroups'])
        : null;
    checkbox=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['price'] = price;
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    // data['category'] = this.categoryName;
    // data['toppingGroups'] = this.toppingGrpName;
    data['description']=description;

    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (toppingGroups != null) {
      data['toppingGroups'] = toppingGroups!.toJson();
    }
    return data;
  }
}

class OptionsData {
  String? createdOn;
  String? sId;
  String? name;
  String? price;

  OptionsData({this.createdOn, this.sId, this.name, this.price});

  OptionsData.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdOn'] = createdOn;
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

class Toppings {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? name;
  String? price;
  String? iV;

  Toppings(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.name,
      this.price,
      this.iV});

  Toppings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    price = json['price'].toString();
    iV = json['__v'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['price'] = price;
    data['__v'] = iV;
    return data;
  }
}

class CategoryData {
  String? sId;
  String? name;

  CategoryData({this.sId, this.name});

  CategoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class ToppingGroupData {
  String? sId;
  String? name;
  String? price;

  ToppingGroupData({this.sId, this.name, this.price});

  ToppingGroupData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

class ItemIds {
  String? sId;
  String? name;
  String? categoryID;

  ItemIds({this.sId, this.name, this.categoryID});

}

class CategoryDataModel {
  late String type, id, name, price, description;
  late bool? checkbox;
  late List<String> selectedData;

  CategoryDataModel(
      this.type, this.id, this.name,  this.price, this.description, this.selectedData,this.checkbox);
}

