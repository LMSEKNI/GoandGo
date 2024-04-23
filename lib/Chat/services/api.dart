
import 'package:dio/dio.dart';
enum UserRole {
  passenger,
  driver,
}


class API {
  final dio = Dio();
  final String baseUrl = "https://wordix-backend.onrender.com";

  getUsersService() async {
    try {
      String url = "https://reqres.in/api/users";

      final response = await dio.get(url);

      return response.data;
    } catch (e) {
      return e;
    }
  }

  loginUserService({required String username, required String password}) async {
    try {
      String url = "$baseUrl/auth/login";

      final data = {
        "email": username,
        "password": password,
      };

      final response = await dio.post(url, data: data);

      return response.data;
    } catch (e) {
      return e;
    }
  }

  registerUserService({
    required String username,
    required String password,
    required UserRole? role, // New parameter for user role
    required String? gender, // Optional parameter for gender
    String? vehicleModel, // Optional parameter for vehicle model
  }) async {
    try {
      String url = "$baseUrl/auth/register";

      // Create the data map with the required parameters
      final data = {
        "email": username,
        "password": password,
        "passwordConfirm": password,
        // Add the role if provided
        if (role != null) "role": role
            .toString()
            .split('.')
            .last,
        // Add the vehicleModel if provided and the role is driver
        if (role == UserRole.driver &&
            vehicleModel != null) "vehicleModel": vehicleModel,
        // Add the gender if provided
        if (gender != null) "gender": gender,
      };

      final response = await dio.post(url, data: data);

      return response.data;
    } catch (e) {
      return e;
    }
  }
}
