import 'dart:io';
import 'dart:developer' show log;
import 'package:mime/mime.dart';

import './chunk_stream.dart';
import './extension.dart';
import './part_form.dart';

extension ComplementForRequestMultipartInHttpOI on HttpRequest {

  Future<List<PartForm>> getFormParts() async{

    final List<PartForm> parts = [];

    final ContentType? contentType = headers.contentType;

    final String mimeType = contentType?.mimeType ?? '';

    if (!mimeType.contains('multipart/form-data')) {
      log(
        'O content-type deve ser do tipo [multipart/form-data]',
        name: 'getFormParts',
      );
      return parts;
    }

    try {

      final String boundary = contentType?.parameters['boundary'] 
        ?? PartFormExeception.generate<String>('O boundary não foi definido');

      // final List<List<int>> bodyParts = await toList();

      // if (bodyParts.isEmpty) {
      //   log(
      //     'O body da requisição não foi definido',
      //     name: 'getFormParts',
      //   );
      //   return parts;
      // }

      // final Stream<MimeMultipart> multPartsStream = MimeMultipartTransformer(boundary)
      //   .bind(Stream.fromIterable(bodyParts)).asBroadcastStream();

      final Stream<MimeMultipart> multPartsStream = MimeMultipartTransformer(boundary)
        .bind(this).asBroadcastStream();

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
      throw PartFormExeception(error.message);
    } on MimeMultipartException catch(error, stackTrace) {
      final String message = 'Erro ao tentar carregar os dados [Stream<MimeMultipart>], '
        'provavelmente os dados do body na requisição multipart está totalmente vazia';
      log(
        message,
        name: 'getFormParts',
        error: error,
        stackTrace: stackTrace,
      );
      throw PartFormExeception(message);
    } on PartFormExeception catch(error, stackTrace) {
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
      throw PartFormExeception(message);
    }
  }

}