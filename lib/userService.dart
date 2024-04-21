import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin/userModel.dart';


class UserService {
  final dio = Dio();
  final String _dataSource = "Bettrillion";
  final String _database = "bettrillion";
  final String _collection = "userMapping";
  final String _endpoint = "https://ap-south-1.aws.data.mongodb-api.com/app/data-ehiqk/endpoint/data/v1";
  static const _apiKey = "iYAP9lLJI4nTfzugswcGJWjb8MzQbp954mFxSskYIuYSafyPcgPEqOM228iE20yJ";
  var headers = {
    "content-type": "application/json",
    "Access-Control-Request-Headers":"*",
    "apiKey": _apiKey,
  };


  Future<List<User>> getUsers() async {
    var response = await dio.post(
      "$_endpoint/action/find",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {},
        },
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => User.fromJson(json)).toList();
      return userList;
    } else {
      throw Exception('Error getting Users');
    }
  }


  Future<List<User>> getUser(String userEmail) async {
    var response = await dio.post(
      "$_endpoint/action/find",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {"userEmail":"${userEmail}"},
        },
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => User.fromJson(json)).toList();
      return userList;
    } else {
      throw Exception('Error getting Bets');
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

  Future createUser(User user) async {
    var response = await dio.post(
      "$_endpoint/action/insertOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "document": user.toJson()
        },
      ),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error creating bet');
    }
  }

  Future deleteUser(User user) async {
    var response = await dio.post(
      "$_endpoint/action/deleteOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "userEmail": "${user.userEmail}"
          }
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