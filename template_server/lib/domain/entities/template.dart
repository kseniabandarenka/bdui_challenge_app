class Template {
  final String name;
  final Map<String, dynamic> content;
  final DateTime lastModified;

  Template({
    required this.name,
    required this.content,
    required this.lastModified,
  });
}

class RenderedTemplate {
  final String name;
  final Map<String, dynamic> content;
  final Map<String, dynamic> data;

  RenderedTemplate({
    required this.name,
    required this.content,
    required this.data,
  });
}
