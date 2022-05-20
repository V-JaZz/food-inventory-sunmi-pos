// ignore_for_file: unnecessary_new

class ToppingsGroupListResponseModel {
  bool? success;
  List<ToppingsGroupListData>? data;

  ToppingsGroupListResponseModel({required this.success, required this.data});

  ToppingsGroupListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ToppingsGroupListData>[];
      json['data'].forEach((v) {
        data!.add(new ToppingsGroupListData.fromJson(v));
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

class ToppingsGroupListData {
  List<ToppingsData>? toppings;
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? description;
  String? price;
  String? toppingIds;

  ToppingsGroupListData(
      {required this.toppings,
        required this.createdOn,
        required this.isDeleted,
        required this.sId,
        required this.name,
        required this.description,
        required this.price,
        required this.toppingIds});

  ToppingsGroupListData.fromJson(Map<String, dynamic> json) {
    if (json['toppings'] != null) {
      toppings = <ToppingsData>[];
      json['toppings'].forEach((v) {
        toppings!.add(new ToppingsData.fromJson(v));
      });
    }
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
    toppingIds = json['toppingIds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['toppingIds'] = toppingIds;
    return data;
  }
}

class ToppingsData {
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? price;
  String? iV;

  ToppingsData(
      {required this.createdOn,
        required this.isDeleted,
        required this.sId,
        required this.name,
        required this.price,
        required this.iV});

  ToppingsData.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
    iV = json['__v'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['__v'] = iV;
    return data;
  }
}