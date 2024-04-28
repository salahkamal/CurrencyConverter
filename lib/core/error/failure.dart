import 'package:currency_converter/core/error/exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

class OfflineFailure extends Failure {
  const OfflineFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class InternalCacheFailure extends Failure {
  const InternalCacheFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class NoEndpointFailure extends Failure {
  const NoEndpointFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class NotAllowedFailure extends Failure {
  const NotAllowedFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class LimitFailure extends Failure {
  const LimitFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class FormatFailure extends Failure {
  const FormatFailure(super.message);

  @override
  List<Object?> get props => [message];
}

Failure handleFailure(Exception e) {
  if (e is ServerException) {
    return ServerFailure(e.message);
  } else if (e is InvalidCredentialsException) {
    return InvalidCredentialsFailure(e.message);
  } else if (e is NotAllowedException) {
    return NotAllowedFailure(e.message);
  } else if (e is NoEndpointException) {
    return NoEndpointFailure(e.message);
  } else if (e is ValidationException) {
    return ValidationFailure(e.message);
  } else if (e is LimitException) {
    return LimitFailure(e.message);
  } else if (e is OfflineException) {
    return OfflineFailure(e.message);
  } else if (e is EmptyCacheException) {
    return EmptyCacheFailure(e.message);
  } else if (e is InternalCacheException) {
    return InternalCacheFailure(e.message);
  } else if (e is FormatException) {
    return FormatFailure(e.message);
  } else {
    return const ServerFailure('');
  }
}
