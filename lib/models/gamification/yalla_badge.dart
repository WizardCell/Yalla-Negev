import '../surveys/localized_text.dart';
import 'badge_condition.dart';

export 'badge_condition.dart';
export 'earned_badge.dart';

class YallaBadge {
  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final String icon;
  final BadgeCondition condition;

  YallaBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.condition,
  });

  factory YallaBadge.fromMap(String id, Map<String, dynamic> data) {
    return YallaBadge(
      id: id,
      name: LocalizedText.fromMap(data['name']),
      description: LocalizedText.fromMap(data['description']),
      icon: data['icon'],
      condition: BadgeCondition.fromMap(data['condition']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name.toMap(),
      'description': description.toMap(),
      'icon': icon,
      'condition': condition.toMap(),
    };
  }
}
