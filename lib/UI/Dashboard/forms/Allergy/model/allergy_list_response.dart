class AllergyListResponseModel {
  bool? success;
  List<AllergyListData>? data;

  AllergyListResponseModel({required this.success, required this.data});

  AllergyListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AllergyListData>[];
      json['data'].forEach((v) {
        data!.add(AllergyListData.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['_id'] = sId;
    data['name'] = name;
    data['restaurantId'] = restaurantId;
    return data;
  }
}
