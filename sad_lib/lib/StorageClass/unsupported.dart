import 'dart:typed_data';

class StorageClass {
  StorageClass._();

  Future<Map<String, dynamic>> readFromMap(String filename){
    throw "Storage Error: Platform Not Supported!";
  }

  Future<void> writeToMap(String filename, Map<String, dynamic> data){
    throw "Storage Error: Platform Not Supported!";
  }


  Future<Map<String, dynamic>> writeToMapUpdate(String filename, String key, dynamic data, {bool replace = true}){
    throw "Storage Error: Platform Not Supported!";
  }

  Future<Map<String, dynamic>> writeToMapUpdateMulti(String filename, Map<String, dynamic> keyValueList, {bool replace = true}){
    throw "Storage Error: Platform Not Supported!";
  }

  Future<void> writeToMapRemove(String filename, String key){
    throw "Storage Error: Platform Not Supported!";
  }


  Future<bool> writeListToMapAdd(String filename, String key, dynamic value, {int limit = 1000}){
    throw "Storage Error: Platform Not Supported!";
  }

  Future<void> writeListToMapRemove(String filename, String key, String value){
    throw "Storage Error: Platform Not Supported!";
  }



  Future<bool> existenceCheck(String filename){
    throw "Storage Error: Platform Not Supported!";
  }

  Future<bool> deleteFile(String filename, {bool isDirectory = false}) {
    throw "Storage Error: Platform Not Supported!";
  }

  Future<bool> renameFile(String oldName, String newName){
    throw "Storage Error: Platform Not Supported!";
  }

  Future<List<Map<String, dynamic>>> loadList({String path = "lists", bool recursive = false}){
    throw "Storage Error: Platform Not Supported!";
  }


  Future<void> saveImage(String filename, Uint8List bytes){
    throw "Storage Error: Platform Not Supported!";
  }
  Future<Uint8List> readImage(String filename){
    throw "Storage Error: Platform Not Supported!";
  }

}
