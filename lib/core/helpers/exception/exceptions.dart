
import 'package:dio/dio.dart';

/// Generic exception to catch and handle resulted error.
class AppException implements Exception {
  final message;
  final details;
  final data;

  const AppException([this.message, this.details, this.data]);

  @override
  String toString() => "message: $message -> Details: $details";
}

class FetchDataException extends AppException {
  const FetchDataException({required String details, data})
      : super("Error During Communication.", details, data);
}

class BadRequestException extends AppException {
  const BadRequestException([details]) : super("Invalid Request.", details);
}

class UnProcessableEntity extends AppException {
  const UnProcessableEntity(message, {required Map<String, dynamic> details})
      : super(message, details);
}

class UnAuthenticatedException extends AppException {
  const UnAuthenticatedException([details]) : super("Unauthorised.", details);
}

class EmailNotFoundException extends AppException {
  const EmailNotFoundException({required String message}) : super(message);

  @override
  String toString() => 'EmailNotFoundException (message: $message)';
}

class ResetPasswordCodeNotValidException extends AppException {
  const ResetPasswordCodeNotValidException(
      String message,
      ) : super(message);

  @override
  String toString() => 'ResetPasswordCodeNotValidException(message: $message)';
}

class EmailAlreadyUsedException extends AppException {
  const EmailAlreadyUsedException(
      String message,
      ) : super(message);

  @override
  String toString() => 'EmailAlreadyUsedException(message: $message)';
}

/// Throw when the developer asks for [PreferenceUtils] method before initializing the [SharedPreferences] package instance.
class PreferenceUtilsNotInitializedException extends AppException {
  const PreferenceUtilsNotInitializedException(
      String message,
      ) : super(message);
}

/// Throw when you try to save an unsupported DataType into [SharedPreferences].
class NotSupportedTypeToSaveException extends AppException {}

class NotFoundRouteException extends AppException {}

/////////////////////////////////

class Failure implements Exception {
  late String message;

  @override
  String toString() => message;

  Failure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with server";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with server";
        break;
      case DioExceptionType.unknown:
        message = "Connection failed due to internet connection";
        break;
      case DioExceptionType.badResponse:
        message = handleError(dioError);
        break;

      case DioExceptionType.badCertificate:
        message = "Connection error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String handleError(DioError dioError) {
    final statusCodeMessages = {
      500: "Server Error",
      401: "Not Authenticated",
      422: "Data is not valid",
      404: "Data Not Found",
      429: "Too many requests",
      403: "Your Request Is Not Allowed",
    };

    // Handle nullable dioError.response and dioError.message
    final statusCode = dioError.response?.statusCode;
    final errorMessage = dioError.message ?? 'Unknown error';

    String message = statusCodeMessages[statusCode] ?? errorMessage;
    return message;
  }
}