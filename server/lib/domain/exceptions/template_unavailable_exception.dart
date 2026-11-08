/// Template server недоступен или вернул ошибку.
class TemplateUnavailableException implements Exception {
  final String reason;

  TemplateUnavailableException(this.reason);

  @override
  String toString() => 'Template server unavailable: $reason';
}
