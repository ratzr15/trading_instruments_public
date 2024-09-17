import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:trading_instruments/src/data/datasource/constants/constants.dart';

import 'trade_symbols_data_source.dart';

class TradeSymbolsDataSourceImpl implements TradeSymbolsDataSource {
  final ApiClient _apiClient;
  final String _baseUrl;

  TradeSymbolsDataSourceImpl({
    required ApiClient apiClient,
    required String baseUrl,
  })  : _apiClient = apiClient,
        _baseUrl = baseUrl;

  @override
  Future<List<dynamic>> call({
    required String exchange,
  }) async {
    if (exchange.isEmpty) {
      throw ArgumentError("Exchange is required");
    }

    final Map<String, dynamic> queryParameters = _toMap(
      exchange,
    );

    const path = 'api/v1/forex/symbol';

    final dynamic response = await _apiClient.get(
      path,
      options: Options(headers: const {}),
      queryParameters: queryParameters,
      baseUrl: _baseUrl,
    );

    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData != null) {
        if (responseData is List) {
          return responseData;
        } else {
          throw Exception(
            "Response is not in proper format, Expected in Map<String, dynamic>",
          );
        }
      } else {
        throw Exception('No response from $path');
      }
    } else {
      throw Exception(
        'Error while fetching news from $path, status code: ${response.statusCode}',
      );
    }
  }

  Map<String, String> _toMap(
    String exchange,
  ) {
    //TODO: move to `.secret` by adapting git secret{https://sobolevn.me/git-secret/}
    return {
      'exchange': exchange,
      'token': TradeDataSourceConstants.apiKey,
    };
  }
}
