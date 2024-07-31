import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/userModel.dart';



class UserService {
  final dio = Dio();
  final String _endpoint = "https://hrhcserver.azurewebsites.net";
  //final String _endpoint = "http://localhost:3000/";
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
      throw Exception('Error fetching Users');
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

  Future<bool> createUser(User user,List accessList) async {
    var userModel=user.toJson();
    userModel["level3Access"]=accessList;
    var response = await dio.post(
      "$_endpoint/addUser",
      options: Options(headers: headers),
      data: userModel,
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error adding customer Customer ${response.statusCode}');
    }
  }


  Future<bool> registerUser(BuildContext context,String mainAccessToken,String username,String email) async {
    /*
Header	Value
Authorization	Bearer {token}. Required. Learn more about authentication and authorization.
Content-Type	application/json
var headers = {
    "content-type": "application/json",
  }
                                   */
    //print(mainAccessToken);
    var azureHeaders = {
      "Authorization":"$mainAccessToken",
      "Content-Type": Headers.jsonContentType,
    };
    var data=jsonEncode({
      "accountEnabled": true,
      "displayName": "$username",
      "mailNickname": "$username",
      "userPrincipalName": "$email",
      "passwordProfile": {"forceChangePasswordNextSignIn": true, "password": "xWwvJ]6NMw+bWH-d"}
    });
    await Future.delayed(Duration(seconds: 2));
    try{
      var response = await dio.post(
        "https://graph.microsoft.com/v1.0/users",
        options: Options(headers: azureHeaders),
        data: data,
      );
      if (response.statusCode == 201) {

        var snackBar = SnackBar(
          content: Text('User Registered ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;
      } else {
        var snackBar = SnackBar(
          content: Text('Error Registering User ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }catch(e){
      var snackBar = SnackBar(
        content: Text((e as DioException).response!.data["error"].toString()),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

  }

  Future<bool> deleteUserFromAzure(BuildContext context,String mainAccessToken,String username,String email) async {
    /*
Header	Value
Authorization	Bearer {token}. Required. Learn more about authentication and authorization.
Content-Type	application/json
var headers = {
    "content-type": "application/json",
  }
                                   */
    //print(mainAccessToken);
    var azureHeaders = {
      "Authorization":"$mainAccessToken",
    };
    await Future.delayed(Duration(seconds: 2));
    try{
      var response = await dio.delete(
        "https://graph.microsoft.com/v1.0/users/$email",
        options: Options(headers: azureHeaders),
      );
      if (response.statusCode == 204) {

        var snackBar = SnackBar(
          content: Text('User Deleted ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;
      } else {
        var snackBar = SnackBar(
          content: Text('Error Deleting User ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }catch(e){
      var snackBar = SnackBar(
        content: Text((e as DioException).response!.data["error"].toString()),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

  }

  Future<bool> assignUpdateUsageLocation(BuildContext context,String mainAccessToken,String username,String email) async {
    /*
Header	Value
Authorization	Bearer {token}. Required. Learn more about authentication and authorization.
Content-Type	application/json
var headers = {
    "content-type": "application/json",
  }
                                   */
    //print(mainAccessToken);
    var azureHeaders = {
      "Authorization":"$mainAccessToken",
      "Content-Type": Headers.jsonContentType,
    };
    var data=jsonEncode({
      "usageLocation": "IN"
    });
    await Future.delayed(Duration(seconds: 2));
    try{
      print("https://graph.microsoft.com/v1.0/users/$email");
      var response = await dio.patch(
        "https://graph.microsoft.com/v1.0/users/$email",
        options: Options(headers: azureHeaders),
        data: data,
      );
      if (response.statusCode == 204) {
        var snackBar = SnackBar(
          content: Text('Updated Usage Location ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;
      } else {
        var snackBar = SnackBar(
          content: Text('Error updating Usage Location ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }catch(e){
      var snackBar = SnackBar(
        content: Text((e as DioException).response!.data["error"].toString()),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return false;
    }

  }

  Future<bool> assignLicenseToUser(BuildContext context,String mainAccessToken,String username,String email) async {
    /*
Header	Value
Authorization	Bearer {token}. Required. Learn more about authentication and authorization.
Content-Type	application/json
var headers = {
    "content-type": "application/json",
  }
                                   */
    //print(mainAccessToken);
    var azureHeaders = {
      "Authorization":"$mainAccessToken",
      "Content-Type": Headers.jsonContentType,
    };
    var data=jsonEncode({
      "addLicenses": [
        {
          "skuId": "3b555118-da6a-4418-894f-7df1e2096870"
        }
      ],
      "removeLicenses": [  ]
    });
    await Future.delayed(Duration(seconds: 2));
    try{
      print("https://graph.microsoft.com/v1.0/users/$email/assignLicense");
      var response = await dio.post(
        "https://graph.microsoft.com/v1.0/users/$email/assignLicense",
        options: Options(headers: azureHeaders),
        data: data,
      );
      if (response.statusCode == 200) {
        var snackBar = SnackBar(
          content: Text('License Assigned to User ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;

      } else {
        var snackBar = SnackBar(
          content: Text('Error Assigning License to User ${response.statusCode}'),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    }catch(e){
      var snackBar = SnackBar(
        content: Text('Error Assigning License to User ${(e as DioException).response!.data["error"].toString()}'),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

  }

  Future deleteUser(User user) async {
    var response = await dio.post(
      "$_endpoint/deleteUser",
      options: Options(headers: headers),
      data: jsonEncode(
        {
            "email": "${user.email}"
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error creating bet');
    }
  }

  Future updateUserAccess(User user,String v1,var list) async {
    try{
      var response = await dio.post(
        "$_endpoint/updateUserPermissions",
        options: Options(headers: headers),
        data: jsonEncode({
          "email": "${user.email}",
          "update": {
            "\$set": {
              "accessLevel": v1,
              "level3Access":list,
              "isLevel1Enabled":user.isLevel1Enabled,
              "isLevel2Enabled":user.isLevel2Enabled,
              "isLevel3Enabled":user.isLevel3Enabled,

            }
          }
        }),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error creating bet');
      }
    }catch(e){
      print((e as DioException).response!.data["error"].toString());
    }
  }
  Future sendUserMessage(User user,String message) async {
    var list=user.notif;
    list?.add({"message": "$message", "timeStamp": DateTime.now().toIso8601String()});
    try{
      var response = await dio.post(
        "$_endpoint/updateUserNotifications",
        options: Options(headers: headers),
        data: jsonEncode({
          "email": "${user.email}",
          "update": {
            "\$set": {
              "notif": list??[{"message": "$message", "timeStamp": DateTime.now().toIso8601String()}],
            }
          }
        }),
      );
      if (response.statusCode == 200) {
        //user.notif=list;
        return response.data;
      } else {
        throw Exception('Error Updating notifications');
      }
    }catch(e){
      print((e as DioException).response!.data["error"].toString());
    }
  }


}