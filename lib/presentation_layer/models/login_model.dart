class UserLoginModel {
  String? status;
  static String? token;
  static Map<String, dynamic>? data;
  static String? photo;
  static String? name;
  static String? email;
  static String? uid;

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? Map<String, dynamic>.of(json['data']) : null;
  }

  static String getUserPhoto() {
    print(data!['user']['photo']);
    return photo = data!['user']['photo'];
  }

  static String getUserName() {
    return name = data!['user']['name'];
  }

  static String getUserEmail() {
    return email = data!['user']['email'];
  }

  static String getUserId() {
    return uid = data!['user']['_id'];
  }
}

// class UserModel {
//   String? photo;
//   String? role;
//   int? followers;
//   int? following;
//
//   String? country;
//   String? language;
//   String? userType;
//   String? createdAt;
//   String? updatedAt;
//   UserModel.fromJson(Map<String, dynamic> json) {
//     photo = json['photo'];
//     role = json['role'];
//     followers = json['followers'];
//     following = json['following'];
//     id = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     country = json['country'];
//     language = json['language'];
//     userType = json['userType'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
// }
