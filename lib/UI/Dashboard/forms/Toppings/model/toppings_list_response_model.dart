class ToppingsListResponseModel {
  bool? success;
  List<ToppingsListData>? data;

  ToppingsListResponseModel({required this.success, required this.data});

  ToppingsListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ToppingsListData>[];
      json['data'].forEach((v) {
        data!.add(ToppingsListData.fromJson(v));
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

class ToppingsListData {
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? description;
  String? price;

  ToppingsListData(
      {required this.createdOn,
      required this.isDeleted,
      required this.sId,
      required this.name,
        required this.description,
      required this.price});

  ToppingsListData.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
