class OptionListResponseModel {
  bool? success;
  List<OptionListData>? data;

  OptionListResponseModel({this.success, this.data});

  OptionListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OptionListData>[];
      json['data'].forEach((v) {
        data!.add(new OptionListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionListData {
  String? sId;
  int? minToppings;
  int? maxToppings;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  String? createdAt;
  String? updatedAt;
  ToppingGroups? toppingGroups;
  List<Toppings>? toppings;

  OptionListData(
      {this.sId,
      this.minToppings,
      this.maxToppings,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.toppingGroups,
      this.toppings});

  OptionListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    minToppings = json['minToppings'];
    maxToppings = json['maxToppings'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    toppingGroups = json['toppingGroups'] != null
        ? new ToppingGroups.fromJson(json['toppingGroups'])
        : null;
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(new Toppings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['minToppings'] = this.minToppings;
    data['maxToppings'] = this.maxToppings;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.toppingGroups != null) {
      data['toppingGroups'] = this.toppingGroups!.toJson();
    }
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToppingGroups {
  String? sId;
  String? name;

  ToppingGroups({this.sId, this.name});

  ToppingGroups.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Toppings {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  int? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Toppings(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt});

  Toppings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    price = json['price'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
