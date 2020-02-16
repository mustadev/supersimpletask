import 'package:flutter/material.dart';


class AttachFile extends Object{
  final String name;
  final String uri;
  AttachFile({ @required this.name, @required this.uri}){
    assert(this.name == null);
    assert(this.uri == null);
  }
  

  static Map<String, dynamic> toJson(AttachFile attachFile){
    return {
      "name": attachFile.name,
      "uri": attachFile.uri
      };
  }

  static AttachFile fromJson(Map<String, dynamic> attachFile){
    return AttachFile(
      name: attachFile["name"],
      uri: attachFile["uri"],
      );
  }

  @override
  bool operator ==(object){
    return this.uri == object.uri;
  }

  @override
  int get hashCode => this.uri.hashCode;  
}
