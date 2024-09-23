// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get_multipart_request/get_multipart_request.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async{

  final ip = '0.0.0.0'; //InternetAddress.anyIPv4;

  final int port = 7000;

  final Router router = Router()
    ..get('/', (Request _) {
      return Response.ok('{"shelfServer":"up"}', headers: {'content-type': 'application/json'});
    })
    ..post('/', (Request request) async{

      final List<PartForm> parts = await request.getFormParts();

      final int length = parts.length;

      final List<dynamic> partsData = List.generate(parts.length, (i) => parts[i].symbolic);

      return Response.ok(
        jsonEncode(partsData),
        headers: {'content-type': 'application/json'},
      );

    });

  final Handler handler = const Pipeline()
    .addMiddleware(logRequests()).addHandler(router.call);

  final HttpServer server = await serve(handler, ip, port);

  log(
    'url: http://localhost:$port/',
    name: 'shelf server > main',
  );

}