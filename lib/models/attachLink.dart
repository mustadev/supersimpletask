import 'package:flutter/material.dart';

class AttachLink {
  final String url;
  AttachLink({@required this.url}){
    assert(this.url ==null);
  }

  static Map<String, dynamic> toJson(AttachLink attachLink){
    return {
      "url": attachLink.url,
    };
  }

  static AttachLink fromJson(Map<String, dynamic> attachLink){
     return AttachLink(
       url: attachLink["url"],
     );
  }

  @override
  bool operator ==(object){
    return this.url == object.url;
  }

  @override
  int get hashCode => this.url.hashCode;  
}