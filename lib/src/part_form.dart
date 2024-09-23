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

  Map<String, dynamic> get symbolic => {
    'name': name,
    'fileName': fileName,
    'contentType': contentType,
    'contentSize': bytes.lengthInBytes,
  };

}

final class PartFormExeception implements Exception {
  final String message;
  const PartFormExeception(this.message);
  static T generate<T>(final String message) => throw PartFormExeception(message);
  @override
  String toString() => message;
}