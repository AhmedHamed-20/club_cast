class SearchRoomsModel {
  static Map<String, dynamic>? searchRoomsModel;
  static List? audienc;
  static List? brodcasters;
  static List? creditBy;
  static String? roomid;
  static String? name;
  static String? roomStatus;
  static String? category;
  static List? getRoomsAudienc() {
    return audienc = searchRoomsModel!['data'][0]['audience'];
  }

  static List? getRoomsBrodcaster() {
    return brodcasters = searchRoomsModel!['data'][0]['brodcasters'];
  }

  static String getRoomID() {
    return roomid = searchRoomsModel!['data'][0]['_id'].toString();
  }

  static String getRoomName() {
    return name = searchRoomsModel!['data'][0]['name'];
  }

  static String getRoomStatus() {
    return roomStatus = searchRoomsModel!['data'][0]['status'];
  }

  static String getRoomsGategory() {
    return category = searchRoomsModel!['data'][0]['category'].toString();
  }

  static List getRoomsUserPublishInform() {
    return creditBy = [searchRoomsModel!['data'][0]['admin']];
  }
}
