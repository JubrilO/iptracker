import 'package:dio/dio.dart';

class DioClient {
  Dio dio = Dio();
  
  DioClient() {
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
  }
}