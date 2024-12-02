import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mongodb_realm/database/mongo_collection.dart';
import 'package:flutter_mongodb_realm/database/mongo_document.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

import '../../main.dart';
import 'fileModel.dart';

class fileResponse {
  String base64;
  String name;
  String extension;

  fileResponse({required this.name, required this.extension, required this.base64});

  Map<dynamic, dynamic> toJson() {
    return {
      "base64": base64,
      "name": name,
      "extension": extension,
    };
  }
}

class FileConvertService {
  final dio = Dio();

  //final String _endpoint = "localhost:3000";
  final String _endpoint = "https://hrhcproxyserver-hwaqdqbchactcdbt.centralindia-01.azurewebsites.net";
  var headers = {
    "content-type": "application/json",
  };
  List<PlatformFile>? _paths;

  Future<UploadFiles> convertToBase64(PlatformFile file) async {
    final extension = file.name.split(".").last.toString();
    //print("$extension-Extension");
    String file64 = base64Encode(file.bytes as List<int>);
    return UploadFiles(base64: file64, name: file.name.split(".").first.toString(), extension: extension);
  }

  Future<UploadFiles> pickFiles() async {
    try {
      _paths = (await FilePickerWeb.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
    if (_paths != null) {
      //passing file bytes and file name for API call
      return convertToBase64(_paths!.first);
    }
    return UploadFiles(extension: "", name: "", base64: "");
  }

  Future<List<UploadFiles>> fetchAttachments() async {
    var response = await dio.post(
      "$_endpoint/fetchAttachments",
      options: Options(headers: headers),
      data: jsonEncode(
        {},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => UploadFiles.fromJson(json)).toList();

      //print("Attachment List-${userList.length}");
      return userList;
    } else {
      throw Exception('Error Username or Password Incorect');
    }
  }

  Future<bool> deleteAttachment(
    String name,
    String extension,
  ) async {
    var response = await dio.post(
      "$_endpoint/deleteAttachment",
      options: Options(headers: headers),
      data: jsonEncode(
        {"name": name, "extension": extension},
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error Customer');
    }
  }

  Future<List<UploadFiles>> fetchAttachmentsForUser(String customerID) async {
    var response = await dio.post(
      "$_endpoint/fetchAttachmentsForUser",
      options: Options(headers: headers),
      data: jsonEncode(
        {"forCustomer": customerID},
      ),
    );
    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var userList = respList.map((json) => UploadFiles.fromJson(json)).toList();
      return userList;
    } else {
      throw Exception('Error Username or Password Incorect');
    }
  }

  Future<bool> uploadFiles(String base64,MongoCollection collectionBanner,bool isImageBanner,String companyId) async {
    try{
      await collectionBanner.insertOne(MongoDocument({
        "companyId": companyId.toString(),
        "type": isImageBanner?"bannerImage":"bannerText",
        "base64": base64,
      }));
      //print("object");
    }catch(e){
      print(e);
    }
    return true;
  }

  Future<bool> uploadFilesForDP(fileResponse fr, String uploadedBy, String forCustomer) async {
    var temp =
        UploadFiles(name: fr.name, base64: fr.base64, extension: fr.extension, forCustomer: forCustomer, uploadedBy: uploadedBy);
    var response = await dio.post(
      "$_endpoint/action/insertOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {"document": temp.toJson()},
      ),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error adding customer Customer ${response.statusCode}');
    }

    return true;
  }
}
