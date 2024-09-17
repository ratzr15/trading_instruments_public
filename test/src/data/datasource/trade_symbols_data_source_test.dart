import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trading_instruments/src/data/datasource/constants/constants.dart';
import 'package:trading_instruments/src/data/datasource/trade_symbols_data_source/trade_symbols_data_source.dart';
import 'package:trading_instruments/src/data/datasource/trade_symbols_data_source/trade_symbols_data_source_impl.dart';

void main() {
  late TradeSymbolsDataSource sut;
  late ApiClientMock apiClientMock;
  const String baseUrlDummy = "https://example.org";

  setUp(() {
    registerFallbackValue(Options());

    // given
    apiClientMock = ApiClientMock();

    sut = TradeSymbolsDataSourceImpl(
      apiClient: apiClientMock,
      baseUrl: baseUrlDummy,
    );
  });

  test(
      'Success: When datasource is called, should call apiClient with correct parameters',
      () async {
    // Given
    final responseData = [
      {
        'description': 'description1',
        'displaySymbol': 'displaySymbol1',
        'symbol': 'symbol1',
      },
      {
        'description': 'description2',
        'displaySymbol': 'displaySymbol2',
        'symbol': 'symbol2',
      },
    ];

    when(
      () => apiClientMock.get(
        any(),
        options: any(named: "options"),
        baseUrl: any(named: "baseUrl"),
        queryParameters: any(named: "queryParameters"),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    // When
    final actual = await sut(
        exchange: 'forex'); // Ensure sut expects an 'exchange' parameter

    // Then
    expect(actual, responseData);

    verify(() => apiClientMock.get(
          'api/v1/forex/symbol',
          options: any(named: "options"),
          queryParameters: {
            'exchange': 'forex',
            'token': TradeDataSourceConstants
                .apiKey, // Ensure this is the correct token
          },
          baseUrl: baseUrlDummy, // Ensure baseUrlDummy is correctly set up
        )).called(1);
  });

  test('Failure: throws ArgumentError when exchange is not passed', () async {
    // given
    final Response<dynamic> response = Response(
      statusCode: 400,
      requestOptions: RequestOptions(path: ''),
    );
    when(
      () => apiClientMock.get(
        any(),
        options: any(named: "options"),
        baseUrl: any(named: "baseUrl"),
        queryParameters: any(named: "queryParameters"),
      ),
    ).thenAnswer(
      (_) async => response,
    );

    // when & then
    await expectLater(
      () => sut(exchange: ''),
      throwsA(isA<ArgumentError>()),
    );
  });
}

class ApiClientMock extends Mock implements ApiClient {}
