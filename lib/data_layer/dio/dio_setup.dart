import 'package:dio/dio.dart';

class DioHelper {
  static late Response response;
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: "https://audiocomms-podcast-platform.herokuapp.com/api/",
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<dynamic> getDate({
    String? url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? token,
  }) async {
    return response = await dio!.get(
      url!,
      queryParameters: query,
      options: Options(headers: token),
    );
  }

  static Future<dynamic> deleteData(
      {String? url,
      Map<String, dynamic>? query,
      Map<String, dynamic>? token}) async {
    return response = await dio!.delete(
      url!,
      queryParameters: query,
      options: Options(headers: token),
    );
  }

  static Future<dynamic> postData(
      {required String url,
      required Map<String, dynamic> data,
      Map<String, dynamic>? token}) async {
    return await dio!.post(url, data: data, options: Options(headers: token));
  }
}
