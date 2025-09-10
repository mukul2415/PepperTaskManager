import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object?> get props => [properties];
}

class LocalDatabaseFailure extends Failure {
  final String message;

  LocalDatabaseFailure({this.message = 'Failed to access local database.'})
    : super([message]);
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure({this.message = 'Server error occurred.'}) : super([message]);
}

class ValidationFailure extends Failure {
  final String message;

  ValidationFailure({this.message = 'Validation failed.'}) : super([message]);
}
