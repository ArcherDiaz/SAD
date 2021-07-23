export 'unsupported.dart'
  if(dart.library.html) 'web.dart'
  if(dart.library.io)'mobile.dart';



class FileEntity{

  String name;
  String parent;
  String fullPath;
  String extension;

  FileEntity({this.name, this.parent, this.fullPath, this.extension});


}