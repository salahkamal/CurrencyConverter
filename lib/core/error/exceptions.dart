import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class EmptyCacheException implements Exception {
  final String message;

  EmptyCacheException(this.message);
}

class OfflineException implements Exception {
  final String message;

  OfflineException(this.message);
}

class InternalCacheException implements Exception {
  final String message;

  InternalCacheException(this.message);
}

class NoEndpointException implements Exception {
  final String message;

  NoEndpointException(this.message);
}

class NotAllowedException implements Exception {
  final String message;

  NotAllowedException(this.message);
}

class InvalidCredentialsException implements Exception {
  final String message;

  InvalidCredentialsException(this.message);
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);
}

class LimitException implements Exception {
  final String message;

  LimitException(this.message);
}

Exception handleExceptions(Response<dynamic> response) {
  if (response.statusCode == 401) {
    return InvalidCredentialsException(response.data['message'] ?? '');
  } else if (response.statusCode == 403) {
    return NotAllowedException(response.data['message'] ?? '');
  } else if (response.statusCode == 404) {
    return NoEndpointException(response.data['message'] ?? '');
  } else if (response.statusCode == 422) {
    return ValidationException(response.data['message'] ?? '');
  } else if (response.statusCode == 429) {
    return LimitException(response.data['message'] ?? '');
  } else if (response.statusCode == 500) {
    return ServerException(response.data['message'] ?? '');
  } else {
    return const FormatException('Failed to parse data');
  }
}
