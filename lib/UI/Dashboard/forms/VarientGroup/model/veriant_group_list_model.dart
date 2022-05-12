class VarientGroupListModel {
  bool? success;
  List<VarientGroupList>? data;

  VarientGroupListModel({this.success, this.data});

  VarientGroupListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VarientGroupList>[];
      json['data'].forEach((v) {
        data!.add(VarientGroupList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VarientGroupList {
  List<VariantsGroup>? variants;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? sId;
  String? name;
  String? variantIds;
  String? createdAt;
  String? updatedAt;

  VarientGroupList(
      {this.variants,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.sId,
      this.name,
      this.variantIds,
      this.createdAt,
      this.updatedAt});

  VarientGroupList.fromJson(Map<String, dynamic> json) {
    if (json['variants'] != null) {
      variants = <VariantsGroup>[];
      json['variants'].forEach((v) {
        variants!.add(VariantsGroup.fromJson(v));
      });
    }
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    sId = json['_id'];
    name = json['name'];
    variantIds = json['variantIds'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['restaurantId'] = restaurantId;
    data['_id'] = sId;
    data['name'] = name;
    data['variantIds'] = variantIds;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class VariantsGroup {
  String? variantGroup;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? sId;
  String? name;
  int? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  VariantsGroup(
      {this.variantGroup,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.sId,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt});

  VariantsGroup.fromJson(Map<String, dynamic> json) {
    variantGroup = json['variantGroup'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['variantGroup'] = variantGroup;
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['restaurantId'] = restaurantId;
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
