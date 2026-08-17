import 'package:dio/dio.dart';
import 'package:gallaemalae/core/network/api_exception.dart';

class FestivalRemoteDataSource {
  const FestivalRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> search(Map<String, dynamic> query) =>
      _get('/api/v1/festivals', queryParameters: query);

  Future<Map<String, dynamic>> getDetail(int id) =>
      _get('/api/v1/festivals/$id');

  Future<Map<String, dynamic>> analyze(int id, String date) =>
      _get('/api/v1/festivals/$id/analysis', queryParameters: {'date': date});

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
        options: Options(listFormat: ListFormat.multi),
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ApiException(message: '서버 응답 형식이 올바르지 않습니다.');
      }
      return data;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
