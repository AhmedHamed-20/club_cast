class CategoryModel {
  static Map<String, dynamic>? allCategory;
  static String? id;
  static String? name;

  static String getCategoryID(int index) {
    return id = allCategory!['data'][index]['_id'];
  }

  static String getCategoryName(int index) {
    return id = allCategory!['data'][index]['name'];
  }
}
