import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

class StorageClass {
  StorageClass._();

  Future<Map<String, dynamic>> readFromMap(String filename){
    Map<String, dynamic> data = Map();
    if(html.window.localStorage.containsKey(filename)) {
      data = json.decode(html.window.localStorage[filename]);
    }
    return Future.value(data);
  }

  Future<void> writeToMap(String filename, Map<String, dynamic> data){
    html.window.localStorage.update(filename, (value) => json.encode(data), ifAbsent: ()=> json.encode(data));
    return Future.value(null);
  }


  Future<Map<String, dynamic>> writeToMapUpdate(String filename, String key, dynamic data, {bool replace = true}){
    //Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename).then((contents){
      if(replace == true) {
        contents.update(key, (value) => data, ifAbsent: () => data);
      }else{
        contents.update(key, (value) => value+data, ifAbsent: () => data);
      }

      html.window.localStorage.update(filename, (value) => json.encode(contents), ifAbsent: ()=> json.encode(contents));
      return Future.value(contents);
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

      html.window.localStorage.update(filename, (value) => json.encode(contents), ifAbsent: ()=> json.encode(contents));
      return Future.value(contents);
    });
  }

  Future<void> writeToMapRemove(String filename, String key){
    return readFromMap(filename).then((contents){
      if(contents.containsKey(key)) {
        contents.remove(key);
      }

      html.window.localStorage.update(filename, (value) => json.encode(contents), ifAbsent: ()=> json.encode(contents));
      return Future.value(null);
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

      html.window.localStorage.update(filename, (value) => json.encode(contents), ifAbsent: ()=> json.encode(contents));
      return Future.value(true);
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

      html.window.localStorage.update(filename, (value) => json.encode(contents), ifAbsent: ()=> json.encode(contents));
      return Future.value(null);
    });
  }



  Future<bool> existenceCheck(String filename){
    return Future.value(html.window.localStorage.containsKey(filename));
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
    html.window.localStorage.update(newName, (value) => html.window.localStorage[oldName],
        ifAbsent: ()=> html.window.localStorage[oldName],
    );
    html.window.localStorage.remove(oldName);

    return Future.value(html.window.localStorage.containsKey(newName));
  }

  Future<List<Map<String, dynamic>>> loadList({String path = "lists", bool recursive = false}){
    List<Map<String, dynamic>> data = List();
    if(html.window.localStorage.containsKey(path)) {
      data = json.decode(html.window.localStorage[path]);
    }
    return Future.value(data);
  }


  Future<void> saveImage(String filename, Uint8List bytes){
    html.window.localStorage.update(filename, (value) => json.encode(bytes), ifAbsent: ()=> json.encode(bytes));
    return Future.value(null);
  }
  Future<Uint8List> readImage(String filename){
    Uint8List data;
    if(html.window.localStorage.containsKey(filename)) {
      data = json.decode(html.window.localStorage[filename]);
    }
    return Future.value(data);
  }

}
