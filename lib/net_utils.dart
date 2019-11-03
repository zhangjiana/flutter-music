import 'package:dio/dio.dart';

class NetUtils {
  static Dio _dio;
  static final String baseUrl = "http://47.98.222.11";

  static void init() {
    print('$baseUrl:3000');
    _dio = Dio(BaseOptions(baseUrl: '$baseUrl:3000', followRedirects: false));
  }

  static Future getDailySongsData() async {
    try {
      Response response = await _dio.get('/artists?id=5771');
      return response.data;
    } catch (e) {
      print(e);
    }
  }
  // 获取歌曲url
  static Future getSongUrl(int id) async {
    try {
      var data = {'id': id};
      Response response = await _dio.get('/song/url',
        queryParameters: data
      );
      return response.data['data'][0]['url'];
    } catch (e) {
      print(121);
      print(e);
    }
  }
}