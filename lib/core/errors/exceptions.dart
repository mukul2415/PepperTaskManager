class LocalDatabaseException implements Exception {
  final String message;
  const LocalDatabaseException([this.message = 'An unexpected local database error occurred.']);

  @override
  String toString() => 'LocalDatabaseException: $message';
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'An unexpected server error occurred.']);

  @override
  String toString() => 'ServerException: $message';
}