class ActiveRoomAdminModel {
  static Map<String, dynamic>? activeRoomAdminData;
  static String? adminId;
  static String? adminName;
  static String? adminPhoto;
  static String? adminSocketId;
  static String? roomName;

  static Map<String, dynamic>? activeRoomData;
  static List? audienc;
  static List? brodcasters;
  static String? adminToken;
  static String? roomId;
  static List getRoomsAudienc() {
    return audienc = [activeRoomData!['audience']];
  }

  static List getRoomsBrodCasters() {
    return brodcasters = [activeRoomData!['brodcasters']];
  }

  static String getJoinToken() {
    return adminToken!;
  }

  static String getRoomId() {
    return roomId = activeRoomData!['_id'];
  }

  static String getAdminId() {
    return adminId = activeRoomAdminData!['id'].toString();
  }

  static String getAdminName() {
    return adminName = activeRoomAdminData!['name'];
  }

  static String getAdminPhoto() {
    return adminName = activeRoomAdminData!['photo'];
  }

  static String getRoomName() {
    return roomName = activeRoomAdminData!['roomName'].toString();
  }
}
