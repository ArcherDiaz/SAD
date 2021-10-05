import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sad_lib/StorageClass/StorageClass.dart';

class StorageClass {
  StorageClass();

  Future<Map<String, dynamic>> readFromMap(String filename){
    Map<String, dynamic> _data = Map();
    return getApplicationDocumentsDirectory().then((xDirectory){
      File _file;
      if(filename.contains(xDirectory.path,)){
        _file = File(filename);
      }else{
        _file = File("${xDirectory.path}/$filename");
      }
      return _file.exists().then((flag){
        if(flag) {
          _data = json.decode(_file.readAsStringSync(),);
          return _data;
        }else{
          return _data;
        }
      });
    });
  }

  Future<void> writeToMap(String filename, Map<String, dynamic> data){
    return getApplicationDocumentsDirectory().then((xDirectory) {
      return File("${xDirectory.path}/$filename").create(recursive: true,).then((file){
        String _fileData = json.encode(data,);
        return file.writeAsString(_fileData, flush: true, mode: FileMode.write,).then((useless) {
          return;
        });
      });
    });
  }


  Future<Map<String, dynamic>> writeToMapUpdate(String filename, String key, dynamic data, {bool replace = true}){
    // Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename,).then((contents){
      if(replace == true) {
        contents.update(key, (value) => data, ifAbsent: () => data);
      }else{
        contents.update(key, (value) => value+data, ifAbsent: () => data);
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        String fileData = json.encode(contents);
        return file.writeAsString(fileData, flush: true, mode: FileMode.write,).then((value){
          return contents;
        });
      });
    });
  }

  Future<Map<String, dynamic>> writeToMapUpdateMulti(String filename, Map<String, dynamic> keyValueList, {bool replace = true}){
    //Get map from json file then replace the data if it exists, otherwise create it
    return readFromMap(filename,).then((contents){
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
        File file = File("${xDirectory.path}/$filename",);
        String fileData = json.encode(contents);
        return file.writeAsString(fileData, flush: true, mode: FileMode.write,).then((value){
          return contents;
        });
      });
    });
  }

  Future<void> writeToMapRemove(String filename, String key){
    return readFromMap(filename,).then((contents){
      if(contents.containsKey(key)) {
        contents.remove(key);
      }
      return getApplicationDocumentsDirectory().then((xDirectory) {
        File file = File("${xDirectory.path}/$filename");
        String fileData = json.encode(contents);
        return file.writeAsString(fileData, flush: true, mode: FileMode.write,).then((value){
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
        String fileData = json.encode(contents);
        return file.writeAsString(fileData, flush: true, mode: FileMode.write).then((value) {
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
        String fileData = json.encode(contents);
        return file.writeAsString(fileData, flush: true, mode: FileMode.write).then((value) {
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

  Future<List<FileEntity>> loadList(String path, {bool recursive = false, String extension = ".diaz"}){
    List<FileEntity> _data = [];
    return getApplicationDocumentsDirectory().then((xDirectory){
      return Directory("${xDirectory.path}/$path").list(recursive: recursive,).forEach((file) {
        if(file.path.endsWith(extension)) {
          _data.add(FileEntity(
            name: file.path.substring(file.path.lastIndexOf("/")+1, file.path.lastIndexOf(".")),
            parent: file.parent.path.substring(file.parent.path.lastIndexOf("/")+1),
            fullPath: file.absolute.path,
            extension: extension,
            creationDate: file.statSync().modified,
          ));
        }
      }).then((useless){
        return _data;
      });
    });
  }


  Future<void> saveImage(String filename, Uint8List bytes){
    return getApplicationDocumentsDirectory().then((xDirectory) {
      return File("${xDirectory.path}/$filename").create(recursive: true).then((file) {
        return file.writeAsBytes(bytes.toList(), flush: true, mode: FileMode.write).then((value){
          return null;
        });
      });
    });
  }
  Future<Uint8List> readImage(String filename){
    return getApplicationDocumentsDirectory().then((xDirectory) {
      return File("${xDirectory.path}/$filename").readAsBytes();
    });
  }

}
