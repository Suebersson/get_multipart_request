import 'dart:async';
import 'dart:typed_data';

// Referência: https://pub.dev/packages/chunked_stream
Future<Uint8List> readByteStream(Stream<List<int>> input, {int? maxSize}) async {

  if ((maxSize ?? 1) < 0) {
    throw ChunkStreamExeception('O atributo maxSize deve ser positivo: $maxSize');
  }

  final BytesBuilder result = BytesBuilder();

  await for (final List<int> chunk in input) {
    result.add(chunk);
    if (maxSize != null && result.length > maxSize) {
      throw ChunkStreamExeception('O comprimento dos bytes é maior do que o tamanho '
        'máximo definido: $maxSize');
    }
  }

  return result.takeBytes();
  
}

final class ChunkStreamExeception implements Exception {
  final String message;
  const ChunkStreamExeception(this.message);
  @override
  String toString() => message;
}

extension ComplementForStreamListInt on Stream<List<int>> {
  Future<Uint8List> get getByteStream => readByteStream(this);
}