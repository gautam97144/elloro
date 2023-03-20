class TokenHistory {
  int? success;
  List<Data>? data;
  String? message;

  TokenHistory({this.success, this.data, this.message});

  TokenHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? tokenTransactionId;
  int? userId;
  int? token;
  int? type;
  String? message;
  int? status;
  String? createdAt;
  Null? updatedAt;

  Data(
      {this.tokenTransactionId,
      this.userId,
      this.token,
      this.type,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    tokenTransactionId = json['token_transaction_id'];
    userId = json['user_id'];
    token = json['token'];
    type = json['type'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_transaction_id'] = this.tokenTransactionId;
    data['user_id'] = this.userId;
    data['token'] = this.token;
    data['type'] = this.type;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
