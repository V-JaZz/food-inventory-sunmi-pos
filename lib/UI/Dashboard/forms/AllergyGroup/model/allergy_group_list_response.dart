class AllergyGroupListResponseModel {
  bool? success;
  List<AllergyGroupListData>? data;

  AllergyGroupListResponseModel({required this.success, required this.data});

  AllergyGroupListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AllergyGroupListData>[];
      json['data'].forEach((v) {
        data!.add(new AllergyGroupListData.fromJson(v));
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

class AllergyGroupListData {
  List<AllergyData>? allergies;
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? description;
  String? price;
  String? toppingIds;

  AllergyGroupListData(
      {required this.allergies,
        required this.createdOn,
        required this.isDeleted,
        required this.sId,
        required this.name,
        required this.description,
        required this.price,
        required this.toppingIds});

  AllergyGroupListData.fromJson(Map<String, dynamic> json) {
    if (json['allergies'] != null) {
      allergies = <AllergyData>[];
      json['allergies'].forEach((v) {
        allergies!.add(new AllergyData.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allergies != null) {
      data['allergies'] = this.allergies!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['toppingIds'] = this.toppingIds;
    return data;
  }
}

class AllergyData {
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? price;
  String? iV;

  AllergyData(
      {required this.createdOn,
        required this.isDeleted,
        required this.sId,
        required this.name,
        required this.price,
        required this.iV});

  AllergyData.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
    iV = json['__v'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['__v'] = this.iV;
    return data;
  }
}