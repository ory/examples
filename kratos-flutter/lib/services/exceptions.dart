import 'package:dio/dio.dart';

enum OryExceptionType {
  //exception for an expired session token.
  unauthorizedException,

  //exception for an incorrect parameter in a request/response.
  badRequestException,

  //The exception for an unknown type of failure.
  unknownException,

  //The exception for an expired flow
  flowExpiredException
}

class CustomException implements Exception {
  final String? message;

  final int? statusCode;
  final OryExceptionType exceptionType;

  CustomException({
    statusCode,
    this.message = 'An error occured. Please try again later',
    this.exceptionType = OryExceptionType.unknownException,
  }) : statusCode = statusCode ?? 500;

  factory CustomException.fromDioException(DioException error) {
    try {
      switch (error.type) {
        case DioExceptionType.unknown:
          if (error.response?.statusCode == 401) {
            return CustomException(
              exceptionType: OryExceptionType.unauthorizedException,
              statusCode: error.response?.statusCode,
              message: error.response?.data?['error']['message'],
            );
          } else if (error.response?.statusCode == 410) {
            return CustomException(
              exceptionType: OryExceptionType.flowExpiredException,
              statusCode: error.response?.statusCode,
              message: error.response?.data?['error']['message'],
            );
          } else {
            return CustomException(statusCode: error.response?.statusCode);
          }
        default:
          return CustomException(statusCode: error.response?.statusCode);
      }
    } on Exception catch (_) {
      return CustomException();
    }
  }
}
