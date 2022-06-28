class UserModelId {
  String? status;
  UserData? data;

  UserModelId.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  String? id;
  String? photo;
  int? followers;
  int? following;
  String? name;
  String? country;
  String? language;
  String? userType;
  bool? isFollowed;
  String? bio;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    json['photo'] == null
        ? photo =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3-lQXGq-2WPJR5aE_l74q-mR61wDrZXUYhA&usqp=CAU'
        : photo = json['photo'];
    followers = json['followers'];
    following = json['following'];
    name = json['name'];
    country = json['country'];
    language = json['language'];
    userType = json['userType'];
    isFollowed = json['isFollowed'];
    bio = json['bio'];
  }
}

// class SaveDataModel {
//   static Map<String, dynamic>? savaData;
//   static String? photoUrl;
//   static String? userid;
//   static String? name;
//
//   static String getUserID() {
//     return userid =
//         savaData!['data']['_id'];
//   }
//
//   static String getUserName() {
//     return name = savaData!['data']['name'];
//   }
//
//   static String getPhotoUrltName(int index) {
//     return photoUrl = savaData!['data']['photo'];
//   }
// }
