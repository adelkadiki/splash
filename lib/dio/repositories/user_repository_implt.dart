import 'package:chatapp/dio/api_endpoints.dart';
import 'package:chatapp/dio/authentication/token_storage_service.dart';
import 'package:chatapp/dio/dio_client.dart';
import 'package:chatapp/dio/models/user.dart';
import 'package:chatapp/dio/repositories/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImplt implements UserRepository {
  UserRepositoryImplt({
    required DioClient dioClient,
    required TokenStorageService tokenStrorateService,
  }) : _dioClient = dioClient,
       _tokenStorageService = tokenStrorateService;

  final DioClient _dioClient;
  final TokenStorageService _tokenStorageService;

  // New user method
  @override
  Future<User> createUser(User user) async {
    try {
      final response = await _dioClient.client.post(
        ApiEndpoints.users,
        data: user.toJson(),
      );
      if (response.data is Map<String, dynamic>) {
        return User.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw NetworkException(message: 'Faild to parse created user response');
      }
    } on DioException catch (e) {
      throw _rethrowAsNetworkException(e);
    } catch (e) {
      throw NetworkException(message: 'Faild to retreive User');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      await _dioClient.client.delete('${ApiEndpoints.users}/$id');
    } on DioException catch (e) {
      throw _rethrowAsNetworkException(e);
    } catch (e) {
      throw NetworkException(message: 'Faild to retreive User');
    }
  }

  // Get a User method
  @override
  Future<User> getUser(int id) async {
    try {
      final response = await _dioClient.client.get('${ApiEndpoints.users}/$id');

      if (response.data is Map<String, dynamic>) {
        return User.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw NetworkException(
          message: 'Received User is not an object format',
        );
      }
    } on DioException catch (e) {
      throw _rethrowAsNetworkException(e);
    } catch (e) {
      throw NetworkException(message: 'Faild to retreive User');
    }
  }

  // Get all users method
  @override
  Future<List<User>> getUsers() async {
    try {
      final response = await _dioClient.client.get(ApiEndpoints.users);

      if (response.data is List) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw NetworkException(message: 'Not List format');
      }
    } on DioException catch (e) {
      throw _rethrowAsNetworkException(e);
    } catch (e) {
      throw NetworkException(message: 'Faild to process Users list : $e');
    }
  }

  // Update user method
  @override
  Future<User> updateUser(User user) async {
    try {
      final response = await _dioClient.client.put(
        '${ApiEndpoints.users}/$user.id',
      );
      if (response.data is Map<String, dynamic>) {
        return User.fromJson(response.data);
      } else {
        throw NetworkException(message: 'Faild parsing updatd user');
      }
    } on DioException catch (e) {
      throw _rethrowAsNetworkException(e);
    } catch (e) {
      throw NetworkException(message: 'Faild to retreive User');
    }
  }

  // Check if the DioException object has NetworkException instance
  // unpack it, and return it as a NetworkException object
  Exception _rethrowAsNetworkException(DioException e) {
    if (e.error is NetworkException) {
      return e.error as NetworkException;
    }
    return NetworkException(
      message: 'Network error occured : ${e.message}',
      statusCode: e.response?.statusCode,
    );
  }

  // USer login
  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final resposne = await _dioClient.client.post(
        'Login_URL',
        data: {'username': username, 'password': password},
      );

      // Make sure the received data in a right format
      final data = resposne.data as Map<String, dynamic>;

      final String token = data['token'] as String;
      _tokenStorageService.saveToken(token);

      final userJson = data['user'] as Map<String, dynamic>;

      return User.fromJson(userJson);
    } on DioException catch (e) {
      throw _rethrowAsNetworkException(e);
    } catch (e) {
      throw NetworkException(message: 'Error retreiving a user $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.client.post('Logout URL');
    } catch (_) {
      // Ignore network failures on logout so local cleanup always succeeds
    } finally {
      await _tokenStorageService.deleteToken();
    }
  }
}
