import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gallaemalae/core/logging/logger_provider.dart';

class ApiLogInterceptor extends Interceptor {
  ApiLogInterceptor(this._logger);

  static const _maxBodyLength = 4000;
  static const _listPreviewCount = 2;
  static const _startedAtKey = 'api_log_started_at';
  static const _sensitiveHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
  };

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now();
    _logger.info(
      '┌─ ▶ API REQUEST\n'
      '│ ${options.method} ${options.uri}\n'
      '│ Headers  ${_inline(_safeHeaders(options.headers))}\n'
      '${_block('Body', options.data)}\n'
      '└────────────────────────────────────────',
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
      '┌─ ✓ API RESPONSE · ${response.statusCode} · ${_elapsed(request)}\n'
      '│ ${request.method} ${request.uri}\n'
      '${_block('Body', response.data)}\n'
      '└────────────────────────────────────────',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    _logger.error(
      '┌─ ✕ API ERROR · ${err.response?.statusCode ?? '-'} · ${_elapsed(request)}\n'
      '│ ${request.method} ${request.uri}\n'
      '│ Type     ${err.type.name}\n'
      '│ Message  ${err.message ?? '-'}\n'
      '${_block('Body', err.response?.data)}\n'
      '└────────────────────────────────────────',
    );
    handler.next(err);
  }

  Map<String, Object?> _safeHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      final hidden = _sensitiveHeaders.contains(key.toLowerCase());
      return MapEntry(key, hidden ? '***' : value);
    });
  }

  String _elapsed(RequestOptions request) {
    final startedAt = request.extra[_startedAtKey];
    if (startedAt is! DateTime) return '-';
    return '${DateTime.now().difference(startedAt).inMilliseconds}ms';
  }

  String _block(String label, Object? value) {
    if (value == null) return '│ $label     -';
    final lines = _pretty(value).split('\n');
    return ['│ $label', ...lines.map((line) => '│   $line')].join('\n');
  }

  String _inline(Object? value) => _pretty(value).replaceAll('\n', ' ');

  String _pretty(Object? value) {
    String text;
    try {
      text = const JsonEncoder.withIndent('  ').convert(_summarize(value));
    } catch (_) {
      text = value.toString();
    }
    if (text.length <= _maxBodyLength) return text;
    return '{\n  "summary": "응답이 너무 커서 표시를 생략했어요.",\n'
        '  "type": "${value.runtimeType}"\n}';
  }

  Object? _summarize(Object? value) {
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), _summarize(item)),
      );
    }
    if (value is List) {
      if (value.length <= _listPreviewCount) {
        return value.map(_summarize).toList(growable: false);
      }
      return {
        'count': value.length,
        'preview': value
            .take(_listPreviewCount)
            .map(_summarize)
            .toList(growable: false),
        'omitted': value.length - _listPreviewCount,
      };
    }
    return value;
  }
}
