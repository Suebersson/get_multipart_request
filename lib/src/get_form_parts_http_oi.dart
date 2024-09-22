import 'dart:developer' show log;
import 'dart:typed_data' show Uint8List;
import 'dart:io' show HttpRequest;
import 'package:mime/mime.dart';

import './chunk_stream.dart';
import './extension.dart';
import './part_form.dart';

extension ComplementForRequestMultipartInHttpOI on HttpRequest {

  Future<List<PartForm>> getFormParts() async{

    final List<PartForm> parts = [];

    final String contentType = headers.contentType?.mimeType ?? '';

    if (!contentType.contains('multipart/form-data')) {
      log(
        'O content-type deve ser do tipo [multipart/form-data]',
        name: 'getFormParts',
      );
      return parts;
    }

    try {

      final String boundary = headers.contentType?.parameters['boundary'] 
        ?? FormDataFieldExeception.generate<String>('O boundary não foi definido');

      final Stream<Uint8List> body = asBroadcastStream();

      final bool isEmpty = await body.isEmpty;

      if (isEmpty) {
        log(
          'O corpo da requisição não foi definido',
          name: 'getFormParts',
        );
        return parts;
      }

      final Stream<MimeMultipart> multPartsStream = MimeMultipartTransformer(boundary)
        .bind(body).asBroadcastStream();

        await multPartsStream.forEach((MimeMultipart part) async{
          final Map<String, String> headers = part.headers;
          final String contentDisposition = headers.contentDisposition;
          parts.add(
            PartForm(
              name: headers.getFormPartName(contentDisposition), 
              fileName: headers.getFormPartFileName(contentDisposition), 
              contentType: headers.contentType, 
              bytes: await readByteStream(part),
            ),
          );
        },);

      return parts;
      
    } on StateError catch(error, stackTrace) {
      log(
        error.message,
        name: 'getFormParts',
        error: error,
        stackTrace: stackTrace,
      );
      throw FormDataFieldExeception(error.message);
    } on MimeMultipartException catch(error, stackTrace) {
      final String message = 'Erro ao tentar carregar os dados da lista de objetos [MimeMultipart]';
      log(
        message,
        name: 'getFormParts',
        error: error,
        stackTrace: stackTrace,
      );
      throw FormDataFieldExeception(message);
    } on FormDataFieldExeception catch(error, stackTrace) {
      log(
        error.message,
        name: 'getFormParts',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch(error, stackTrace) {
      final String message = 'Erro não tratado ao tentar obter os campos numa requisição '
        'do tipo [multipart/form-data]';
      log(
        message,
        name: 'getFormParts',
        error: error,
        stackTrace: stackTrace,
      );
      throw FormDataFieldExeception(message);
    }
  }

}