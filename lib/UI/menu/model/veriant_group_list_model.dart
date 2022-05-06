class VarientGroupListModel {
  bool? success;
  List<VarientGroupList>? data;

  VarientGroupListModel({this.success, this.data});

  VarientGroupListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VarientGroupList>[];
      json['data'].forEach((v) {
        data!.add(new VarientGroupList.fromJson(v));
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
        variants!.add(new VariantsGroup.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['variantIds'] = this.variantIds;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variantGroup'] = this.variantGroup;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
