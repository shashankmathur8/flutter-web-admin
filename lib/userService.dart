import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin/userModel.dart';



class UserService {
  final dio = Dio();
  final String _endpoint = "https://ap-south-1.aws.data.mongodb-api.com/app/data-ehiqk/endpoint/data/v1";
  var headers = {
    "content-type": "application/json",
  };


  Future<bool> checkUserPassword(String userEmail, String password) async {
    var response = await dio.post(
      "$_endpoint/userLogin",
      options: Options(headers: headers),
      data: jsonEncode(
        {"username": "${userEmail}", "password": "${password}"},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => User.fromJson(json)).toList();
      if (userList.length > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Error Username or Password Incorect');
    }
  }

  Future<User> fetchUser(String userEmail, String password) async {
    var response = await dio.post(
      "$_endpoint/userFetch",
      options: Options(headers: headers),
      data: jsonEncode(
        {"username": "${userEmail}", "password": "${password}"},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => User.fromJson(json)).toList();
      if (userList.length > 0) {
        return userList.first;
      }
      return User(username: "Null");
    } else {
      print("'Error Username or Password Incorect' ${response.statusCode}");
      throw Exception('Error Username or Password Incorect');
    }
  }
  Future<User> fetchCurrentUser(String userEmail) async {
    var response = await dio.post(
      "$_endpoint/fetchCurrentUser",
      options: Options(headers: headers),
      data: jsonEncode(
        {"username": "${userEmail}"},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => User.fromJson(json)).toList();
      if (userList.length > 0) {
        return userList.first;
      }
      return User(username: "Null");
    } else {
      throw Exception('Error Username or Password Incorect');
    }
  }

  Future<List<User>> fetchAllUser() async {
    var response = await dio.post(
      "$_endpoint/fetchAllUsers",
      options: Options(headers: headers),
      data: jsonEncode(
        {},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => User.fromJson(json)).toList();


      return userList;

    } else {
      throw Exception('Error fetching Userst');
    }
  }

  Future<String> getIP() async {
    try {
      const url = 'https://api.ipify.org';
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        print(response.data);
        return "null";
      }
    } catch (exception) {
      print(exception);
      return "null";
    }
  }

  Future<bool> createUser(User user) async {
    var response = await dio.post(
      "$_endpoint/addUser",
      options: Options(headers: headers),
      data: user.toJson(),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error adding customer Customer ${response.statusCode}');
    }
  }

  Future deleteUser(User user) async {
    var response = await dio.post(
      "$_endpoint/deleteUser",
      options: Options(headers: headers),
      data: jsonEncode(
        {
            "userEmail": "${user.username}"
        },
      ),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error creating bet');
    }
  }


}