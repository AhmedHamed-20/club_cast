class GetAllRoomsModel {
  static Map<String, dynamic>? getAllRooms;
  static List? audienc;
  static List? brodcasters;
  static List? creditBy;
  static String? roomid;
  static String? name;
  static String? roomStatus;
  static String? category;
  static List getRoomsAudienc(int index) {
    return audienc = [getAllRooms?['data'][index]['audience']];
  }

  static List? getRoomsBrodcaster(int index) {
    return brodcasters = [getAllRooms!['data'][index]['brodcasters']];
  }

  static String getRoomID(int index) {
    return roomid = getAllRooms!['data'][index]['_id'].toString();
  }

  static String getRoomName(int index) {
    return name = getAllRooms!['data'][index]['name'];
  }

  static String getRoomStatus(int index) {
    return roomStatus = getAllRooms!['data'][index]['status'];
  }

  static String getRoomsGategory(int index) {
    return category = getAllRooms!['data'][index]['category'].toString();
  }

  static List getRoomsUserPublishInform(int index) {
    return creditBy = [getAllRooms!['data'][index]['admin']];
  }
}
