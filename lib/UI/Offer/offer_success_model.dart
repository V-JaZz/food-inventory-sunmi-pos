class OfferSuccessModel{
  bool? success;
  String? data;

  OfferSuccessModel(this.success,this.data, );

  OfferSuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] == null ? "" : json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!;
    }
    return data;
  }
}