import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/core/network/api_exception.dart';

void main() {
  test('응답 타임아웃을 사용자용 메시지로 변환한다', () {
    final exception = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/analysis'),
        type: DioExceptionType.receiveTimeout,
      ),
    );

    expect(exception.code, 'TIMEOUT');
    expect(exception.message, '서버 응답이 지연되고 있어요. 잠시 후 다시 시도해 주세요.');
  });
}
