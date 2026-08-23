import 'package:dio/dio.dart';
import 'package:gallaemalae/core/network/api_exception.dart';

class FestivalRemoteDataSource {
  const FestivalRemoteDataSource(this._dio, {this.onListRetrying});

  final Dio _dio;
  final void Function(bool isRetrying)? onListRetrying;

  Future<Map<String, dynamic>> search(Map<String, dynamic> query) => _get(
    '/api/v1/festivals',
    queryParameters: query,
    receiveTimeout: const Duration(seconds: 30),
    retryOnceOnTimeout: true,
  );

  Future<Map<String, dynamic>> getDetail(int id) =>
      _get('/api/v1/festivals/$id');

  Future<Map<String, dynamic>> analyze(int id, String date) => _get(
    '/api/v1/festivals/$id/analysis',
    queryParameters: {'date': date},
    receiveTimeout: const Duration(seconds: 30),
  );

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration? receiveTimeout,
    bool retryOnceOnTimeout = false,
  }) async {
    try {
      final response = await _request(
        path,
        queryParameters: queryParameters,
        receiveTimeout: receiveTimeout,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ApiException(message: '서버 응답 형식이 올바르지 않습니다.');
      }
      return data;
    } on DioException catch (error) {
      if (retryOnceOnTimeout && _isTimeout(error)) {
        onListRetrying?.call(true);
        try {
          final response = await _request(
            path,
            queryParameters: queryParameters,
            receiveTimeout: receiveTimeout,
          );
          final data = response.data;
          if (data is! Map<String, dynamic>) {
            throw const ApiException(message: '서버 응답 형식이 올바르지 않습니다.');
          }
          return data;
        } on DioException catch (retryError) {
          throw ApiException.fromDio(retryError);
        } finally {
          onListRetrying?.call(false);
        }
      }
      throw ApiException.fromDio(error);
    }
  }

  Future<Response<Object?>> _request(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration? receiveTimeout,
  }) => _dio.get<Object?>(
    path,
    queryParameters: queryParameters,
    options: Options(
      listFormat: ListFormat.multi,
      receiveTimeout: receiveTimeout,
    ),
  );
}

bool _isTimeout(DioException error) =>
    error.type == DioExceptionType.receiveTimeout ||
    error.type == DioExceptionType.connectionTimeout ||
    error.type == DioExceptionType.sendTimeout;
