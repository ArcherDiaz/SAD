import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class StorageClass {
  StorageClass._();

  Future<Map<String, dynamic>> readFromMap(String filename){
    Map<String, dynamic> data = Map();
    return getApplicationDocumentsDirectory().then((xDirectory){
      File file = File("${xDirectory.path}/$filename");
      return file.exists().then((flag){
        if(flag) {
          data = json.decode(file.readAsStringSync());
          return data;
        }else{
          return data;
        }
      });
    });
  }

  Future<void> writeToMap(String filename, Map<String, dynamic> data){
    return getApplicationDocumentsDirectory().then((xDirectory) {
      return File("${xDirectory.path}/$filename").create(recursive: true).then((file){
        return file.writeAsString(json.encode(data), flush: true, mode: FileMode.write).then((value) {
          return;
        });
      });
    });
  }


  Future<Map<String, dynamic>> writeToMapUpdate(String filename, String key, dynamic data, {bool replace = true}){
    //Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename).then((contents){
      if(replace == true) {
        contents.update(key, (value) => data, ifAbsent: () => data);
      }else{
        contents.update(key, (value) => value+data, ifAbsent: () => data);
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        return file.writeAsString(json.encode(contents), flush: true, mode: FileMode.write).then((value){
          return contents;
        });
      });
    });
  }

  Future<Map<String, dynamic>> writeToMapUpdateMulti(String filename, Map<String, dynamic> keyValueList, {bool replace = true}){
    //Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename).then((contents){
      if(replace == true) {
        keyValueList.forEach((key, value) {
          contents.update(key, (val) => value, ifAbsent: () => value);
        });
      }else{
        keyValueList.forEach((key, value) {
          contents.update(key, (val) => val+value, ifAbsent: () => value);
        });
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        return file.writeAsString(json.encode(contents), flush: true, mode: FileMode.write).then((value){
          return contents;
        });
      });
    });
  }

  Future<void> writeToMapRemove(String filename, String key){
    return readFromMap(filename).then((contents){
      if(contents.containsKey(key)) {
        contents.remove(key);
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        return file.writeAsString(json.encode(contents), flush: true, mode: FileMode.write).then((value){
          return;
        });
      });
    });
  }


  Future<bool> writeListToMapAdd(String filename, String key, dynamic value, {int limit = 1000}){
    //Get map from file then check if list already contains a string element, if not then add it then save, otherwise abort
    return readFromMap(filename).then((contents){
      if(contents.containsKey(key)){
        contents[key].insert(0, value);
      }else{
        contents.putIfAbsent(key, () => [value]);
      }
      if(contents[key].length > limit){
        contents[key].removeLast();
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        return file.writeAsString(jsonEncode(contents), flush: true, mode: FileMode.write).then((value) {
          return true;
        });
      });
    });
  }

  Future<void> writeListToMapRemove(String filename, String key, String value){
    //Get map from file then check if list contains a string element, if yes then remove it then save, otherwise abort
    return readFromMap(filename).then((contents){
      if(contents.containsKey(key)){
        if(contents[key].contains(value)) {
          contents[key].remove(value);
        }
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        return file.writeAsString(jsonEncode(contents), flush: true, mode: FileMode.write).then((value) {
          return;
        });
      });
    });
  }



  Future<bool> existenceCheck(String filename){
    return getApplicationDocumentsDirectory().then((xDirectory){
      final file = File("${xDirectory.path}/$filename");
      return file.exists();
    });
  }

  Future<bool> deleteFile(String filename, {bool isDirectory = false}) {
    return getApplicationDocumentsDirectory().then((xDirectory){
      if(isDirectory == false){
        File file = File("${xDirectory.path}/$filename");
        return file.exists().then((flag){
          if(flag){
            return file.delete(recursive: false).then((value) => value.exists());
          }else {
            return true;
          }
        });
      }else{
        Directory dir = Directory("${xDirectory.path}/$filename");
        return dir.exists().then((flag){
          if(flag){
            return dir.delete(recursive: false).then((value) => value.exists());
          }else {
            return true;
          }
        });
      }
    });
  }

  Future<bool> renameFile(String oldName, String newName){
    return getApplicationDocumentsDirectory().then((xDirectory){
      final file = File("${xDirectory.path}/$oldName");
      return file.rename("${xDirectory.path}/$newName").then((value){
        return value.exists();
      });
    });
  }

  Future<List<Map<String, dynamic>>> loadList({String path = "lists", bool recursive = false}){
    List<Map<String, dynamic>> data = List();
    return getApplicationDocumentsDirectory().then((dir){
      return Directory("${dir.path}/$path").list(recursive: recursive).forEach((file) {
        if(file.path.endsWith(".diaz")) {
          data.add({
            "name": file.path.substring(file.path.lastIndexOf("/")+1, file.path.lastIndexOf(".")),
            "parent": file.parent.path.substring(file.parent.path.lastIndexOf("/")+1),
          });
        }
      }).then((value){
        return data;
      });
    });
  }


  Future<void> saveImage(String filename, Uint8List bytes){
    return getApplicationDocumentsDirectory().then((xDirectory) {
      return File("${xDirectory.path}/images/$filename").create(recursive: true).then((file) {
        return file.writeAsBytes(bytes.toList(), flush: true, mode: FileMode.write).then((value){
          return null;
        });
      });
    });
  }
  Future<Uint8List> readImage(String filename){
    return getApplicationDocumentsDirectory().then((xDirectory) {
      return File("${xDirectory.path}/images/$filename").readAsBytes();
    });
  }

}