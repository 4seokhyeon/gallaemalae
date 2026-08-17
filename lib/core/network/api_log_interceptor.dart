import 'package:dio/dio.dart';
import 'package:gallaemalae/core/logging/logger_provider.dart';

class ApiLogInterceptor extends Interceptor {
  ApiLogInterceptor(this._logger);

  static const _maxBodyLength = 4000;
  static const _sensitiveHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
  };

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.info(
      'API REQUEST ${options.method} ${options.uri}\n'
      'headers=${_safeHeaders(options.headers)}\n'
      'body=${_body(options.data)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final request = response.requestOptions;
    _logger.info(
      'API RESPONSE ${response.statusCode} ${request.method} ${request.uri}\n'
      'body=${_body(response.data)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    _logger.error(
      'API ERROR ${err.response?.statusCode ?? '-'} '
      '${request.method} ${request.uri}\n'
      'type=${err.type.name}\n'
      'response=${_body(err.response?.data)}',
      error: err.error ?? err.message,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }

  Map<String, Object?> _safeHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      final hidden = _sensitiveHeaders.contains(key.toLowerCase());
      return MapEntry(key, hidden ? '***' : value);
    });
  }

  String _body(Object? value) {
    if (value == null) return '-';
    final text = value.toString();
    if (text.length <= _maxBodyLength) return text;
    return '${text.substring(0, _maxBodyLength)}…(truncated)';
  }
}
