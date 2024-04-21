import 'dart:convert';
import 'package:dio/dio.dart';

import 'betsModel.dart';


class BetService {
  final dio = Dio();
  final String _dataSource = "Bettrillion";
  final String _database = "bettrillion";
  final String _collection = "bets";
  final String _endpoint = "https://ap-south-1.aws.data.mongodb-api.com/app/data-ehiqk/endpoint/data/v1";
  static const _apiKey = "iYAP9lLJI4nTfzugswcGJWjb8MzQbp954mFxSskYIuYSafyPcgPEqOM228iE20yJ";
  var headers = {
    "content-type": "application/json",
    "Access-Control-Request-Headers":"*",
    "apiKey": _apiKey,
  };


  Future<List<Bet>> getAllBets() async {
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
      var BetList = respList.map((json) => Bet.fromJson(json)).toList();
      return BetList;
    } else {
      throw Exception('Error getting Bets');
    }
  }

  Future<List<Bet>> getBet() async {
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
      var BetList = respList.map((json) => Bet.fromJson(json)).toList();
      return BetList;
    } else {
      throw Exception('Error getting Bets');
    }
  }

  Future createBet(Bet bet) async {
    var response = await dio.post(
      "$_endpoint/action/insertOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "document": bet.toJson()
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