class UserModelId
{
  String? status;
  UserData? data;

  UserModelId.fromJson(Map<String, dynamic>json)
  {
    status=json['status'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null ;
  }
}

class UserData
{
  String? id;
  String? photo;
  int? followers;
  int? following;
  String? name;
  String? country;
  String? language;
  String? userType;

  UserData.fromJson(Map<String, dynamic>json)
  {
    id=json['_id'];
    photo=json['photo'];
    followers=json['followers'];
    following=json['following'];
    name=json['name'];
    country=json['country'];
    language=json['language'];
    userType=json['userType'];
  }



}