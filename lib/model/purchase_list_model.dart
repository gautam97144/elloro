class PurchaseList {
  int? success;
  List<PurchaseData>? data;
  String? message;

  PurchaseList({this.success, this.data, this.message});

  PurchaseList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <PurchaseData>[];
      json['data'].forEach((v) {
        data!.add(PurchaseData.fromJson(v));
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

class PurchaseData {
  String? category;
  List<PurchaseCatalog>? data;

  PurchaseData({this.category, this.data});

  PurchaseData.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['data'] != null) {
      data = <PurchaseCatalog>[];
      json['data'].forEach((v) {
        data!.add(new PurchaseCatalog.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PurchaseCatalog {
  int? catalogueId;
  int? categoryId;
  int? creatorId;
  String? catalogueUniqueId;
  String? title;
  String? subTitle;
  String? description;
  String? duration;
  String? musicFileSize;
  String? image;
  String? musicFile;
  String? tokenPrice;
  String? purchaseTokenPrice;
  int? status;
  String? createdAt;
  Null? updatedAt;
  String? categoryName;
  String? creatorCode;
  String? creatorName;
  String? creatorEmail;
  String? creatorAbout;
  String? creatorImage;
  int? isIndicator;
  int? userId;
  int? favourite;
  String? avgRate;
  bool? isFavrouiteIconVisible;

  PurchaseCatalog(
      {this.catalogueId,
      this.categoryId,
      this.creatorId,
      this.catalogueUniqueId,
      this.title,
      this.subTitle,
      this.description,
      this.duration,
      this.musicFileSize,
      this.image,
      this.musicFile,
      this.tokenPrice,
      this.purchaseTokenPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.categoryName,
      this.creatorCode,
      this.creatorName,
      this.creatorEmail,
      this.creatorAbout,
      this.creatorImage,
      this.isIndicator,
      this.userId,
      this.favourite,
      this.avgRate,
      this.isFavrouiteIconVisible});

  PurchaseCatalog.fromJson(Map<String, dynamic> json) {
    catalogueId = json['catalogue_id'];
    categoryId = json['category_id'];
    creatorId = json['creator_id'];
    catalogueUniqueId = json['catalogue_unique_id'];
    title = json['title'];
    subTitle = json['sub_title'];
    description = json['description'];
    duration = json['duration'];
    musicFileSize = json['music_file_size'];
    image = json['image'];
    musicFile = json['music_file'];
    tokenPrice = json['token_price'];
    purchaseTokenPrice = json['purchase_token_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
    creatorCode = json['creator_code'];
    creatorName = json['creator_name'];
    creatorEmail = json['creator_email'];
    creatorAbout = json['creator_about'];
    creatorImage = json['creator_image'];
    isIndicator = json['isIndicator'];
    userId = json['user_id'];
    favourite = json['favourite'];
    avgRate = json['avg_rate'];
    isFavrouiteIconVisible = json['isFavrouiteIconVisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catalogue_id'] = this.catalogueId;
    data['category_id'] = this.categoryId;
    data['creator_id'] = this.creatorId;
    data['catalogue_unique_id'] = this.catalogueUniqueId;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['music_file_size'] = this.musicFileSize;
    data['image'] = this.image;
    data['music_file'] = this.musicFile;
    data['token_price'] = this.tokenPrice;
    data['purchase_token_price'] = this.purchaseTokenPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    data['creator_code'] = this.creatorCode;
    data['creator_name'] = this.creatorName;
    data['creator_email'] = this.creatorEmail;
    data['creator_about'] = this.creatorAbout;
    data['creator_image'] = this.creatorImage;
    data['isIndicator'] = this.isIndicator;
    data['user_id'] = this.userId;
    data['favourite'] = this.favourite;
    data['avg_rate'] = this.avgRate;
    data['isFavrouiteIconVisible'] = this.isFavrouiteIconVisible;
    return data;
  }
}
