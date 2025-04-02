// Base class for custom exceptions
class AppException implements Exception {
  // Holds the exception message
  final String? _message;

  // Holds a prefix for the exception message
  final String? _prefix;

  // Constructor for initializing the message and prefix
  AppException([this._message, this._prefix]);

  // Returns a string representation of the exception
  @override
  String toString() {
    return "$_prefix: $_message";
  }
}

// Exception thrown when there is a network or data fetching issue
class FetchDataException extends AppException {
  // Constructor with a default message prefix for communication errors
  FetchDataException([String? message])
      : super(message, "Error During Communication");
}

// Exception thrown for invalid requests, such as incorrect parameters
class BadRequestException extends AppException {
  // Constructor with a default message prefix for bad requests
  BadRequestException([String? message]) : super(message, "Invalid request");
}

// Exception thrown for unauthorized requests, such as authentication failures
class UnauthorizedException extends AppException {
  // Constructor with a default message prefix for unauthorized requests
  UnauthorizedException([String? message])
      : super(message, "Unauthorized request");
}

// Keeping for backward compatibility - use UnauthorizedException instead
@Deprecated('Use UnauthorizedException instead')
class UnathorisedException extends UnauthorizedException {
  UnathorisedException([String? message]) : super(message);
}

// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  // Constructor with a default message prefix for not found errors
  NotFoundException([String? message]) : super(message, "Resource not found");
}

// Exception thrown when a request times out
class TimeoutException extends AppException {
  // Constructor with a default message prefix for timeouts
  TimeoutException([String? message]) : super(message, "Request timeout");
}
