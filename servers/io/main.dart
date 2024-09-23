// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get_multipart_request/get_multipart_request.dart';

void main() async{

  final ip = '0.0.0.0'; //InternetAddress.anyIPv4;

  final int port = 7000;

  final HttpServer server = await HttpServer.bind(ip, port);

  server.listen((HttpRequest request) async{

    final String 
      method = request.method,
      routeName = request.requestedUri.path;

    if (method == 'GET' && routeName == '/') {
      request.response
        ..statusCode = 200
        ..headers.set('content-type', 'application/json')
        // ..headers.contentType = ContentType("application", "json", charset: "utf-8")
        ..write('{"ioServer":"up"}')
        ..close();
    } else if(method == 'POST' && routeName == '/') {

      final List<PartForm> parts = await request.getFormParts();

      final List<dynamic> partsData = List.generate(parts.length, (i) => parts[i].symbolic);

      request.response
        ..statusCode = 200
        ..headers.set('content-type', 'application/json')
        // ..headers.contentType = ContentType("application", "json", charset: "utf-8")
        ..write(jsonEncode(partsData))
        ..close();

    } else {
      request.response
        ..statusCode = 404
        ..headers.set('content-type', 'application/json')
        // ..headers.contentType = ContentType("application", "json", charset: "utf-8")
        ..write('{"notFound":"Rota não encontrada"}')
        ..close();
    }
  },);

  log(
    'url: http://localhost:$port/',
    name: 'dart io server > main',
  );
  
}