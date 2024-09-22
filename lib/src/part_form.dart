import 'dart:typed_data' show Uint8List;

final class PartForm {
  const PartForm({
    required this.name,
    required this.fileName,
    required this.contentType, 
    required this.bytes,
  });
  final String name, fileName, contentType;
  final Uint8List bytes;
}

final class FormDataFieldExeception implements Exception {

  final String message;
  const FormDataFieldExeception(this.message);

  static T generate<T>(final String message) => throw FormDataFieldExeception(message);

  @override
  String toString() => message;
}