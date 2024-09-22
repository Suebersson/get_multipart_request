extension ComplementForHeaders on Map<String, String> {

  String get contentType => this['content-type'] ?? this['Content-type'] ?? this['Content-Type'] ?? '';

  String get contentDisposition => this['content-disposition'] 
    ?? this['Content-disposition'] ?? this['Content-Disposition'] ?? '';

  static final RegExp regExpForGetFormPartName = RegExp(r'(name=".*";|name=".*")');
  static final RegExp regExpForGetFormPartFileName = RegExp(r'(filename=".*";|filename=".*")');
  static final RegExp regExpForClean = RegExp(r'(fileName=|filename=|name=|"|;|\s)');

  String getFormPartName(final String contentDisposition) {
    return regExpForGetFormPartName.stringMatch(contentDisposition)
      ?.replaceAll(regExpForClean, '') ?? '';
  }

  String getFormPartFileName(final String contentDisposition) {
    return regExpForGetFormPartFileName.stringMatch(contentDisposition)
      ?.replaceAll(regExpForClean, '') ?? '';
  }

}