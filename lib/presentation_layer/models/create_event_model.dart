class CreateEventModel {
  static String? status;
  static Map<String, dynamic>? data;

  String eventId() {
    return data!["_id"];
  }

  String userWhoCreateEventId() {
    return data!["createdBy"];
  }

  String eventDate() {
    return data!["date"];
  }

  String eventDescription() {
    return data!["description"];
  }

  String eventName() {
    return data!["name"];
  }
}
