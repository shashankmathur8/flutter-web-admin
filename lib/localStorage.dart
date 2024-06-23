import 'package:universal_html/html.dart';

class LocalStorageHelper{
  static Storage localStorage = window.localStorage;

  getString(String key){
    return localStorage[key];
  }
  saveString(String key,String value){
    localStorage[key]=value;
  }
  removeString(String key){
    localStorage.remove(key);
  }
}