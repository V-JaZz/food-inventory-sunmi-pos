class MenuItems {
  bool? success;
  List<Data>? data;

  MenuItems({this.success, this.data});

  MenuItems.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? name;
  List<Items>? items;

  Data({this.name, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
    String? sId;
    List<Options>? options;
    List<Variants>? variants;
    int? discount;
    String? description;
    bool? excludeDiscount;
    String? name;
    Category? category;
    String? price;
    int? position;
    AllergyGroups? allergyGroups;
    List<Allergies>? allergies;
    String? imageName;

  Items(
      {this.sId,
      this.options,
      this.variants,
      this.discount,
      this.description,
      this.excludeDiscount,
      this.name,
      this.category,
      this.price,
      this.position,
      this.allergyGroups,
      this.allergies,
      this.imageName});

  Items.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
    discount = json['discount'];
    description = json['description'];
    excludeDiscount = json['excludeDiscount'];
    name = json['name'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    price = json['price'].toString();
    position = json['position'];
    allergyGroups = json['allergyGroups'] != null
        ? new AllergyGroups.fromJson(json['allergyGroups'])
        : null;
    if (json['allergies'] != null) {
      allergies = <Allergies>[];
      json['allergies'].forEach((v) {
        allergies!.add(new Allergies.fromJson(v));
      });
    }
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    data['discount'] = this.discount;
    data['description'] = this.description;
    data['excludeDiscount'] = this.excludeDiscount;
    data['name'] = this.name;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['price'] = this.price.toString();
    data['position'] = this.position;
    if (this.allergyGroups != null) {
      data['allergyGroups'] = this.allergyGroups!.toJson();
    }
    if (this.allergies != null) {
      data['allergies'] = this.allergies!.map((v) => v.toJson()).toList();
    }
    data['imageName'] = this.imageName;
    return data;
  }
}

class Options {
  String? minToppings;
  String? maxToppings;
  String? createdOn;
  String? restaurantId;
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? price;
  List<Toppings>? toppings;
  Null? toppingGroup;

  Options(
      {this.minToppings,
      this.maxToppings,
      this.createdOn,
      this.restaurantId,
      this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.toppings,
      this.toppingGroup});

  Options.fromJson(Map<String, dynamic> json) {
    minToppings = json['minToppings'].toString();
    maxToppings = json['maxToppings'].toString();
    createdOn = json['createdOn'];
    restaurantId = json['restaurantId'];
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'];
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(new Toppings.fromJson(v));
      });
    }
    toppingGroup = json['toppingGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minToppings'] = this.minToppings.toString();
    data['maxToppings'] = this.maxToppings.toString();
    data['createdOn'] = this.createdOn;
    data['restaurantId'] = this.restaurantId;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['price'] = this.price;
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    data['toppingGroup'] = this.toppingGroup;
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

class Variants {
  String? sId;
  String? variantGroup;
  String? createdOn;
  String? restaurantId;
  String? name;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? price;
  List<SubVariants>? subVariants;

  Variants(
      {this.sId,
      this.variantGroup,
      this.createdOn,
      this.restaurantId,
      this.name,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.subVariants});

  Variants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variantGroup = json['variantGroup'];
    createdOn = json['createdOn'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'].toString();
    if (json['subVariants'] != null) {
      subVariants = <SubVariants>[];
      json['subVariants'].forEach((v) {
        subVariants!.add(new SubVariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['variantGroup'] = this.variantGroup;
    data['createdOn'] = this.createdOn;
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['price'] = this.price.toString();
    if (this.subVariants != null) {
      data['subVariants'] = this.subVariants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubVariants {
  String? sId;
  String? variantGroup;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  int? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  SubVariants(
      {this.sId,
      this.variantGroup,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt});

  SubVariants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variantGroup = json['variantGroup'];
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
    data['variantGroup'] = this.variantGroup;
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

class Category {
  String? sId;
  String? name;
  int? position;
  String? description;
  int? discount;
  bool? excludeDiscount;

  Category(
      {this.sId,
      this.name,
      this.position,
      this.description,
      this.discount,
      this.excludeDiscount});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    position = json['position'];
    description = json['description'];
    discount = json['discount'];
    excludeDiscount = json['excludeDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['position'] = this.position;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['excludeDiscount'] = this.excludeDiscount;
    return data;
  }
}

class AllergyGroups {
  String? sId;
  String? name;

  AllergyGroups({this.sId, this.name});

  AllergyGroups.fromJson(Map<String, dynamic> json) {
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

class Allergies {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  String? description;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Allergies(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.description,
      this.iV,
      this.createdAt,
      this.updatedAt});

  Allergies.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    description = json['description'];
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
    data['description'] = this.description;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
