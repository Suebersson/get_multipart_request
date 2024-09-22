// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'dart:io' as io;

import 'package:get_multipart_request/get_multipart_request.dart';

void main() async{

  final shelf.Request shelfRequest = request();
  final http.Request httpRequest = request();
  final io.HttpRequest ioRequest = request();

  final List<PartForm> partsByShelf = await shelfRequest.getFormParts();
  final List<PartForm> partsByHttp = await httpRequest.getFormParts();
  final List<PartForm> partsByIo = await ioRequest.getFormParts();

}

T request<T>() {
  return throw 'fake instance';
}