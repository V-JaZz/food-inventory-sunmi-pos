class CommonModel{
  bool? success;
  String? message;

  CommonModel(this.success, this.message);

  CommonModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!;
    }
    return data;
  }
}