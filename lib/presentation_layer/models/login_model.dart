class UserLoginModel {
  String? status;
  String? massage;
  String? token;
  DataModel? data;

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    status = json['massage'];
    token = json['token'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}

class DataModel {
  UserModel? user;
  DataModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }
}

class UserModel {
  String? photo;
  String? role;
  int? followers;
  int? following;
  dynamic id;
  String? name;
  String? email;
  String? country;
  String? language;
  String? userType;
  String? createdAt;
  String? updatedAt;
  UserModel.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    role = json['role'];
    followers = json['followers'];
    following = json['following'];
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    country = json['country'];
    language = json['language'];
    userType = json['userType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
