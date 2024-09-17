import 'package:dio/dio.dart';

import '../api_client.dart';

class ApiClientImpl implements ApiClient {
  final Dio dio;

  ApiClientImpl(this.dio);

  @override
  Future<dynamic> get(
    String url, {
    Options? options,
    String baseUrl = "",
    Map<String, dynamic> queryParameters = const {},
  }) async {
    final apiUrl = '$baseUrl/$url';

    try {
      final response = await dio.get(
        apiUrl,
        options: options,
        queryParameters: queryParameters,
      );
      return response;
    } catch (error) {
      final DioException dioException = error as DioException;
      return dioException.response;
    }
  }
}
