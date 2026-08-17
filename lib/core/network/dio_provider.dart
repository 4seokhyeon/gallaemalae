import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/config/app_env.dart';
import 'package:gallaemalae/core/logging/logger_provider.dart';
import 'package:gallaemalae/core/network/api_log_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    ),
  );
  dio.interceptors.add(ApiLogInterceptor(ref.watch(loggerProvider)));
  return dio;
});
