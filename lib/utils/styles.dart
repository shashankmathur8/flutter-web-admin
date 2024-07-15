
import 'package:flutter/material.dart';

import 'appColors.dart';
enum HistoryType { edit, remove, create,access,error }
class AppStyles{
  static const String version="1.1.2 3 Jul";
  static const t20NWhite = TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.white);
  static const t20NBlack = TextStyle(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.black87);
  static const t22BBlack = TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black87);
  static const t22BPrimary = TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppColors.colorPrimary);
  static const t14NWhite = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.white);

  static const t14Blue = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Color.fromRGBO(34,100,229,1));
  static const t14Red = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.red);
  static const t14BRed = TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.red);
  static const t14NGrey = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Color.fromRGBO(122,122,122,1));
  static const t14NColorDataTable = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: AppColors.colorDataTable);
  static const t10NGrey = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.grey);
  static const t14NBlack = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black87);

  static const t14BBlack = TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black87);
  static const t16BGrey = TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Color.fromRGBO(122,122,122,1));
  static const t16BBlack = TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black87);


  static const t16NWhite = TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.white);
  static const t16NGrey = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Color.fromRGBO(122,122,122,1));
  static const t16NPrimaryColor = TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: AppColors.colorPrimary);

  static const t12NPrimaryHighlight = TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: AppColors.colorPrimaryHighlight);
  static const t16BPrimaryHighlight = TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.colorPrimaryHighlight);
  static const t14NPrimaryColor = TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: AppColors.colorPrimary);
  static const t14BPrimaryColor = TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: AppColors.colorPrimary);
  static const t16BLavender = TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.colorLavenderBG);
  static const t18BBlack = TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87);
  static const t18NBlack = TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black87);
  static const bR10All =BorderRadius.all(Radius.circular(10));

}