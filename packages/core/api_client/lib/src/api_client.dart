import 'package:dio/dio.dart';

abstract class ApiClient {
  Future<dynamic> get(
    String url, {
    Options options,
    String baseUrl = "",
    Map<String, dynamic> queryParameters = const {},
  });
}
