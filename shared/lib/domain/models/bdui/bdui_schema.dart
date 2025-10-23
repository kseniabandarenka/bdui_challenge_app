// shared/domain/models/bdui_schema.dart
class BDUIScreen {
  final String type;
  final String title;
  final BDUILayout layout;

  BDUIScreen({
    required this.type,
    required this.title,
    required this.layout,
  });
}

class BDUILayout {
  final String type;
  final List<BDUIElement> children;

  BDUILayout({
    required this.type,
    required this.children,
  });
}

class BDUIElement {
  final String type;
  final Map<String, dynamic> properties;

  BDUIElement({
    required this.type,
    required this.properties,
  });
}

class BDUIChallengeCard {
  final String id;
  final String title;
  final String category;
  final String description;
  final double progressCurrent;
  final double progressTotal;
  final bool completed;
  final bool isInProgress;
  final double progressPercentage;
  final List<BDUIAction> actions;

  BDUIChallengeCard({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.progressCurrent,
    required this.progressTotal,
    required this.completed,
    required this.isInProgress,
    required this.progressPercentage,
    required this.actions,
  });
}

class BDUIAction {
  final String type;
  final String text;
  final Map<String, dynamic> action;

  BDUIAction({
    required this.type,
    required this.text,
    required this.action,
  });
}