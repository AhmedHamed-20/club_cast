class ActiveRoomUserModel {
  static Map<String, dynamic>? activeRoomUserData;
  static String? userId;
  static String? userName;
  static String? userPhoto;
  static String? userSocketId;
  static String? roomName;

  static Map<String, dynamic>? activeRoomData;
  static List? audienc;
  static List? brodcasters;
  static String? userToken;
  static String? roomId;
  static List getRoomsAudienc() {
    return audienc = [activeRoomData!['audience']];
  }

  static List getRoomsBrodCasters() {
    return audienc = [activeRoomData!['brodcasters']];
  }

  static String getJoinToken() {
    return userToken!;
  }

  static String getRoomId() {
    return roomId = activeRoomData!['_id'];
  }

  static String getUserId() {
    return userId = activeRoomUserData!['id'];
  }

  static String getUserName() {
    return userName = activeRoomUserData!['name'];
  }

  static String getUserPhoto() {
    return userPhoto = activeRoomUserData!['photo'];
  }

  static String? getRoomName() {
    return roomName = activeRoomUserData?['roomName'];
  }
}
