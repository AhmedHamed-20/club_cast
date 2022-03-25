class GetMyFollowingEvents {
  static Map<String, dynamic>? data;

  static String eventId(int index) {
    return data!['data'][index]["_id"];
  }

  static List allEvent() {
    return data!['data'];
  }

  static Map userWhoCreateEvent(int index) {
    return data!['data'][index]["createdBy"];
  }

  static String eventDate(int index) {
    return data!['data'][index]["date"];
  }

  static String eventDescription(int index) {
    return data!['data'][index]["description"];
  }

  static String eventName(int index) {
    return data!['data'][index]["name"];
  }
}
