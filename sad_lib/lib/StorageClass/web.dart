import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:sad_lib/StorageClass/StorageClass.dart';

class StorageClass {
  StorageClass();

  Future<Map<String, dynamic>> readFromMap(String filename){
    Map<String, dynamic> _data = Map();
    return existenceCheck(filename,).then((flag){
      if(flag == true){
        _data = json.decode(html.window.localStorage[filename]);
      }
      return _data;
    });
  }

  Future<void> writeToMap(String filename, Map<String, dynamic> data){
    String fileData = json.encode(data);
    html.window.localStorage.update(filename, (old) => fileData, ifAbsent: ()=> fileData);
    return Future.value(null);
  }


  Future<Map<String, dynamic>> writeToMapUpdate(String filename, String key, dynamic data, {bool replace = true}){
    //Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename,).then((contents){
      if(replace == true) {
        contents.update(key, (old) => data, ifAbsent: () => data);
      }else{
        contents.update(key, (old) => old+data, ifAbsent: () => data);
      }

      String fileData = json.encode(contents);
      html.window.localStorage.update(filename, (value) => fileData, ifAbsent: ()=> fileData);
      return contents;
    });
  }

  Future<Map<String, dynamic>> writeToMapUpdateMulti(String filename, Map<String, dynamic> keyValueList, {bool replace = true}){
    //Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename,).then((contents){
      if(replace == true) {
        keyValueList.forEach((key, value) {
          contents.update(key, (old) => value, ifAbsent: () => value);
        });
      }else{
        keyValueList.forEach((key, value) {
          contents.update(key, (old) => old+value, ifAbsent: () => value);
        });
      }

      String fileData = json.encode(contents);
      html.window.localStorage.update(filename, (value) => fileData, ifAbsent: ()=> fileData);
      return contents;
    });
  }

  Future<void> writeToMapRemove(String filename, String key){
    return readFromMap(filename).then((contents){
      if(contents.containsKey(key)) {
        contents.remove(key);
      }

      String fileData = json.encode(contents);
      html.window.localStorage.update(filename, (value) => fileData, ifAbsent: ()=> fileData);
      return null;
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

      String fileData = json.encode(contents);
      html.window.localStorage.update(filename, (value) => fileData, ifAbsent: ()=> fileData);
      return true;
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

      String fileData = json.encode(contents);
      html.window.localStorage.update(filename, (value) => fileData, ifAbsent: ()=> fileData);
      return null;
    });
  }



  Future<bool> existenceCheck(String filename){
    return Future.value(html.window.localStorage.containsKey(filename,),);
  }

  Future<bool> deleteFile(String filename, {bool isDirectory = false}) {
    return existenceCheck(filename).then((flag){
      if(flag == true){
        html.window.localStorage.remove(filename);
      }
      return flag;
    });
  }

  Future<bool> renameFile(String oldName, String newName){
    return existenceCheck(oldName,).then((flag){
      if(flag == true){
        html.window.localStorage.update(newName, (old) => html.window.localStorage[oldName],
          ifAbsent: ()=> html.window.localStorage[oldName],
        );
        html.window.localStorage.remove(oldName,);
      }

      return html.window.localStorage.containsKey(newName);
    });
  }

  Future<List<FileEntity>> loadList(String path, {bool recursive = false, String extension = ".diaz"}){
    List<FileEntity> _data = [];
    List<String> _storageKeys = html.window.localStorage.keys.toList();
    _storageKeys.where((key) => key.startsWith(path,)).toList().forEach((file) {
      int _index = path.length-1;
      if((file.lastIndexOf("/",)-1) == _index && file.endsWith(extension)) {
        _data.add(FileEntity(
          name: file.substring(file.lastIndexOf("/",)+1, file.lastIndexOf(".",),),
          parent: file.substring(0, _index,),
          fullPath: file,
          extension: extension,
          creationDate: null,
        ));
      }
    });
    return Future.value(_data);
  }


  Future<void> saveImage(String filename, Uint8List bytes){
    String fileData = json.encode(bytes.toList(),);
    html.window.localStorage.update(filename, (old) => fileData, ifAbsent: ()=> fileData,);
    return Future.value(null);
  }
  Future<Uint8List> readImage(String filename){
    Uint8List data;
    return existenceCheck(filename,).then((flag){
      if(flag == true) {
        data = Uint8List.fromList(json.decode(html.window.localStorage[filename],),);
      }
      return data;
    });
  }

}
