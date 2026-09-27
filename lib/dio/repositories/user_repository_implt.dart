import 'package:chatapp/dio/api_endpoints.dart';
import 'package:chatapp/dio/dio_client.dart';
import 'package:chatapp/dio/models/user.dart';
import 'package:chatapp/dio/repositories/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImplt implements UserRepository {

  UserRepositoryImplt(this.dioClient);

  final DioClient dioClient;

  @override
  Future<User> createUser(User user) async{
    
    final response = dioClient.dio.post('${ApiEndpoints.users}/$user', data: user.toJson());
    return User.fromJson(response.data);
     
    
  }

  @override
  Future<void> deleteUser(int id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUser(int id) async {

        final response = await dioClient.dio.get('${ApiEndpoints.users}/$id');
        return User.fromJson(response.data);
  }

  
  // GET ALL USERS
  @override  
  Future<List<User>> getUsers() async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.users,
        // ✅ Specify the generic type
        options: Options(responseType: ResponseType.json),
      );
      
      // ✅ Safe parsing with error handling
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      
      if (response.data is! List) {
        throw Exception('Expected List but got ${response.data.runtimeType}');
      }
      
      return (response.data as List) 
      .cast<Map<String, dynamic>>() 
      .map((user) => User.fromJson(user))
       .toList();
          
    } on DioException catch (e) {
      // Handle network errors
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Handle parsing errors
      throw Exception('Failed to parse users: $e');
    }
  }
  

  @override
  Future<User> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }


}