class Music {
  int? id;
  String? musicTitle;
  String? musicSubtitle;
  String? musicDuration;
  String? image;
  String? description;
  String? creatorAbout;
  String? creatorName;
  String? path;
  int? catalogId;
  int? userId;
  String? musicFileSize;
  String? userProfile;
  int? isDelete;
  int? isFavourite;
  //int? token;
  //String? profileImage;

  Music(
      {this.musicTitle,
      this.musicSubtitle,
      this.musicDuration,
      this.image,
      this.creatorAbout,
      this.description,
      this.creatorName,
      this.path,
      this.userId,
      this.catalogId,
      this.id,
      this.musicFileSize,
      this.userProfile,
      this.isDelete,
      this.isFavourite
      //this.token,
      //this.profileImage,
      });

  Music.fromJson(Map<String, dynamic> json) {
    musicTitle = json['musicTitle'];
    musicSubtitle = json['musicSubtitle'];
    musicDuration = json['musicDuration'];
    image = json['image'];
    id = json['id'];
    description = json['description'];
    creatorAbout = json['creatorAbout'];
    creatorName = json['creatorName'];
    path = json['path'];
    userId = json['userId'];
    catalogId = json['catalogId'];
    musicFileSize = json['musicFileSize'];
    userProfile = json['userProfile'];
    isDelete = json['isDelete'];
    isFavourite = json['isFavourite'];
    //  token = json['token'];
    //profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['musicTitle'] = this.musicTitle;
    data['musicSubtitle'] = this.musicSubtitle;
    data['musicDuration'] = this.musicDuration;
    data['image'] = this.image;
    data['id'] = this.id;
    data['creatorAbout'] = this.creatorAbout;
    data['description'] = this.description;
    data['creatorName'] = this.creatorName;
    data['path'] = this.path;
    data['userId'] = this.userId;
    data['catalogId'] = this.catalogId;
    data['musicFileSize'] = this.musicFileSize;
    data['userProfile'] = this.userProfile;
    data['isDelete'] = this.isDelete;
    data['isFavourite'] = this.isFavourite;
    return data;
  }
}
