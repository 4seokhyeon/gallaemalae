import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.code, this.traceId});

  final String message;
  final String? code;
  final String? traceId;

  factory ApiException.fromDio(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return ApiException(
        message: data['message'] as String? ?? '서버 요청에 실패했습니다.',
        code: data['code'] as String?,
        traceId: data['traceId'] as String?,
      );
    }
    return ApiException(message: error.message ?? '네트워크 연결을 확인해 주세요.');
  }

  @override
  String toString() => message;
}
