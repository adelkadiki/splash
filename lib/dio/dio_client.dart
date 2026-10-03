import 'package:chatapp/dio/api_endpoints.dart';
import 'package:chatapp/dio/authentication/token_storage_service.dart';
import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({required this.message, this.statusCode});

  @override
  String toString() => 'Network Exception: $message (Code: $statusCode)';
}

class DioClient {
  final Dio _dio;
  final TokenStorageService _tokenStorage;

  DioClient({required TokenStorageService tokenStorage})
    : _tokenStorage = tokenStorage,
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handerls) async {
          // Handling Auth token

          final token = await _tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handerls.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenStorage.deleteToken();
          }
          final customeError = _handleDioError(error);
          return handler.reject(customeError);
          // Transform Dio exception into a user friendly error message
        },
      ),
    );
  }

  // Error transformer

  DioException _handleDioError(DioException error) {
    String errorMessage;

    // Check what kind of error is occuring to return the informative error message
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection Time out, check your connection';
        break;

      case DioExceptionType.badResponse:
        errorMessage = _extractResponseBodyError(error.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request has been canceled';
        break;

      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;

      default:
        errorMessage = 'An error occured, please try again';
        break;
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      error: NetworkException(message: errorMessage),
    );
  }

  String _extractResponseBodyError(Response? response) {
    if (response?.data != null && response?.data is Map) {
      return response?.data['message'] ??
          'Server returned error : ${response?.statusCode}';
    }

    return 'Server returned error : ${response?.statusCode}';
  }

  Dio get client => _dio;
}
