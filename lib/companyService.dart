import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'companyModel.dart';


class CompanyService {
  final dio = Dio();
  final String _endpoint = "https://crmproxyserver.azurewebsites.net";
  var headers = {
    "content-type": "application/json",
  };

  Future<Company> fetchCompany(String companyID) async {
    var response = await dio.post(
      "$_endpoint/fetchCompany",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "companyID": "${companyID}",
        },
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => Company.fromJson(json)).toList();
      return userList.first;
    } else {
      throw Exception('Error Username or Password Incorect');
    }
  }


  Future<bool> createCompany(Company company) async {
    try{
      var response = await dio.post("$_endpoint/addCompany", options: Options(headers: headers), data: company.toJson());
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> deleteCompany(Company company) async {
    var response = await dio.post(
      "$_endpoint/deleteCompany",
      options: Options(headers: headers),
      data: jsonEncode(
        {"name": "${company.name}"},
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error Customer');
    }
  }


  Future<List<Company>> fetchAllCompany() async {
    var response = await dio.post(
      "$_endpoint/fetchAllCompanies",
      options: Options(headers: headers),
      data: jsonEncode(
        {},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => Company.fromJson(json)).toList();
      return userList;
    } else {
      throw Exception('Error fetching Companies');
    }
  }


}