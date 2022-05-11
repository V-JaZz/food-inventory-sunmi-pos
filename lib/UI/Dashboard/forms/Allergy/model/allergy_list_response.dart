class AllergyListResponseModel {
  bool? success;
  List<AllergyListData>? data;

  AllergyListResponseModel({required this.success, required this.data});

  AllergyListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AllergyListData>[];
      json['data'].forEach((v) {
        data!.add(new AllergyListData.fromJson(v));
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

class AllergyListData {
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? description;
  String? restaurantId;

  AllergyListData(
      {
        required this.createdOn,
        required this.isDeleted,
        required this.sId,
        required this.name,
        required this.description,
        required this.restaurantId});

  AllergyListData.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    restaurantId = json['restaurantId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['restaurantId'] = this.restaurantId;
    return data;
  }
}
