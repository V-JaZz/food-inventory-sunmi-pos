// class MenuListResponseModel {
//   bool? success;
//   List<MenuItemData>? data = [];

//   MenuListResponseModel({this.success, this.data});

//   MenuListResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <MenuItemData>[];
//       json['data'].forEach((v) {
//         data!.add(new MenuItemData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class MenuItemData {
//   String? sId;
//   List<OptionsData>? options;
//   String? name;
//   String? price;
//   List<Toppings>? toppings;
//   String? description;
//   int? position;
//   bool? excludeDiscount;
//   CategoryData? category;
//   ToppingGroupData? toppingGroups;
//   AllergyGroupData? allergyGroups;
//   int? discount;

//   // String? categoryName;
//   // String? toppingGrpName;

//   MenuItemData(
//       {this.sId,
//       this.options,
//       this.name,
//       this.price,
//       this.toppings,
//       this.description,
//       this.position,
//       this.discount,
//       this.category,
//       this.toppingGroups,
//       this.allergyGroups});

//   MenuItemData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     if (json['options'] != null) {
//       options = <OptionsData>[];
//       json['options'].forEach((v) {
//         options!.add(new OptionsData.fromJson(v));
//       });
//     }
//     name = json['name'];
//     discount = json['discount'];
//     excludeDiscount = json['excludeDiscount'];
//     price = json['price'].toString();
//     if (json['toppings'] != null) {
//       toppings = <Toppings>[];
//       json['toppings'].forEach((v) {
//         toppings!.add(new Toppings.fromJson(v));
//       });
//     }
//     description = json['description'];
//     position = json['position'];
//     // toppingGrpName = json['toppingGroups'];

//     category = json['category'] != null
//         ? new CategoryData.fromJson(json['category'])
//         : null;
//     toppingGroups = json['toppingGroups'] != null
//         ? new ToppingGroupData.fromJson(json['toppingGroups'])
//         : null;
//     allergyGroups = json['allergyGroups'] != null
//         ? new AllergyGroupData.fromJson(json['allergyGroups'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     if (this.options != null) {
//       data['options'] = this.options!.map((v) => v.toJson()).toList();
//     }
//     data['name'] = this.name;
//     data['price'] = this.price;
//     if (this.toppings != null) {
//       data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
//     }
//     data['position'] = this.position;
//     data['discount'] = this.discount;
//     data['description'] = this.description;
//     data['allowDiscount'] = this.excludeDiscount;
//     if (this.category != null) {
//       data['category'] = this.category!.toJson();
//     }
//     if (this.toppingGroups != null) {
//       data['toppingGroups'] = this.toppingGroups!.toJson();
//     }
//     if (this.allergyGroups != null) {
//       data['allergyGroups'] = this.allergyGroups!.toJson();
//     }
//     return data;
//   }

//   removeAt(int oldItemIndex) {}
// }

// class OptionsData {
//   String? createdOn;
//   String? sId;
//   String? name;
//   String? price;

//   OptionsData({this.createdOn, this.sId, this.name, this.price});

//   OptionsData.fromJson(Map<String, dynamic> json) {
//     createdOn = json['createdOn'];
//     sId = json['_id'];
//     name = json['name'];
//     price = json['price'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['createdOn'] = this.createdOn;
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['price'] = this.price;
//     return data;
//   }
// }

// class Toppings {
//   String? sId;
//   String? createdOn;
//   bool? isDeleted;
//   String? name;
//   String? price;
//   String? iV;

//   Toppings(
//       {this.sId,
//       this.createdOn,
//       this.isDeleted,
//       this.name,
//       this.price,
//       this.iV});

//   Toppings.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     createdOn = json['createdOn'];
//     isDeleted = json['isDeleted'];
//     name = json['name'];
//     price = json['price'].toString();
//     iV = json['__v'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['createdOn'] = this.createdOn;
//     data['isDeleted'] = this.isDeleted;
//     data['name'] = this.name;
//     data['price'] = this.price;
//     data['__v'] = this.iV;
//     return data;
//   }
// }

// class CategoryData {
//   String? sId;
//   String? name;
//   int? position;

//   CategoryData({this.sId, this.name, this.position});

//   CategoryData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     position = json['position'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['position'] = this.position;
//     return data;
//   }
// }

// class ToppingGroupData {
//   String? sId;
//   String? name;
//   String? price;

//   ToppingGroupData({this.sId, this.name, this.price});

//   ToppingGroupData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     price = json['price'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['price'] = this.price;
//     return data;
//   }
// }

// class AllergyGroupData {
//   String? sId;
//   String? name;
//   String? description;

//   AllergyGroupData({this.sId, this.name, this.description});

//   AllergyGroupData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     description = json['description'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     return data;
//   }
// }
