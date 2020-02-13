import 'dart:io';

import 'package:ci/tasks/handler_error/strategy_factory_errors.dart';

/// Стратегия для неизвестных ошибок
Future<void> strategyForUnknownErrors(Exception exception, StackTrace stackTrace) {
  print('unknownErrorStrategy: ${exception}');
  return Future.error(exception, stackTrace);
}

/// Стандартная стратегия обработки ошибок
Future<void> standardErrorHandlingStrategy(Exception exception, StackTrace stackTrace) async {
  print(exception);
  exitCode = 1;
}

/// Map со стратегиями обработок ошибок,
Map<Type, ErrorHandlingStrategyFactory> _mapErrorStrategy = {};

/// Геттер мапы, со стратегиями обработок ошибок.
/// [Type] тип ошибки, [ErrorHandlingStrategyFactory] - как обрабатываем ошибку
Map<Type, ErrorHandlingStrategyFactory> get mapErrorStrategy => _mapErrorStrategy;
