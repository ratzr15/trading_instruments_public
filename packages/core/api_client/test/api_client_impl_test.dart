import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late Dio mockDio;
  late ApiClient sut;

  setUp(() {
    mockDio = MockDio();
    sut = ApiClientImpl(mockDio);
  });

  group('Success', () {
    test(
      'EXPECT apiClient to return a success response WHEN get method is called and dio has a valid response',
      () async {
        when(
          () => mockDio.get<dynamic>(
            any(),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: 'data',
            statusCode: 200,
            requestOptions: RequestOptions(path: 'url'),
          ),
        );

        final response = await sut.get('url');
        expect(response, isA<Response<dynamic>>());
      },
    );
  });

  group('Failure', () {
    test(
      'EXPECT apiClient to return a failure response WHEN get method is called and dio has a failure response',
      () async {
        final failureResponse = Response(
          data: 'data',
          statusCode: 400,
          requestOptions: RequestOptions(path: 'url'),
        );

        final failure = DioError(
          requestOptions: RequestOptions(path: 'url'),
          response: failureResponse,
        );

        when(
          () => mockDio.get<dynamic>(
            any(),
            options: any(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(failure);

        final response = await sut.get('url');
        expect(response, failureResponse);
      },
    );
  });
}

class MockDio extends Mock implements Dio {}
