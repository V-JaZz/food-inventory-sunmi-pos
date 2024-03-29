class CategoryListResponseModel {
  bool? success;
  List<CategoryListData>? data;

  CategoryListResponseModel({required this.success, required this.data});

  CategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CategoryListData>[];
      json['data'].forEach((v) {
        data!.add(CategoryListData.fromJson(v));
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

class CategoryListData {
  String? createdOn;
  bool? isDeleted;
  String? sId;
  String? name;
  String? description;

  CategoryListData(
      {required this.createdOn,
      required this.isDeleted,
      required this.sId,
      required this.name,
      required this.description});

  CategoryListData.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['_id'] = sId;
    data['name'] = name;
    if(data['description'] != null)
      {
        data['description'] = description;
      }
    return data;
  }
}
