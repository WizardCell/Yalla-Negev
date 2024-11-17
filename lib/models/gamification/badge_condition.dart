class BadgeCondition {
  final String conditionType;
  final int? value;

  BadgeCondition({required this.conditionType, this.value});

  factory BadgeCondition.fromMap(Map<String, dynamic> data) {
    return BadgeCondition(
      conditionType: data['conditionType'],
      value: data['value'] != null ? data['value'] as int : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conditionType': conditionType,
      if (value != null) 'value': value,
    };
  }
}
