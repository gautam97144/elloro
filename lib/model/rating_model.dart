class Rating {
  int? success;
  Data? data;
  String? message;

  Rating({this.success, this.data, this.message});

  Rating.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? avgRate;

  Data({this.avgRate});

  Data.fromJson(Map<String, dynamic> json) {
    avgRate = json['avg_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg_rate'] = this.avgRate;
    return data;
  }
}
