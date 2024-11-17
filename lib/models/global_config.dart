class GlobalConfig {
  String supportEmail;
  String whatsappLink;

  GlobalConfig({
    required this.supportEmail,
    required this.whatsappLink,
  });

  factory GlobalConfig.fromMap(Map<String, dynamic> data) {
    return GlobalConfig(
      supportEmail: data['supportEmail'] as String,
      whatsappLink: data['whatsappLink'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supportEmail': supportEmail,
      'whatsappLink': whatsappLink,
    };
  }

  GlobalConfig copyWith({
    String? supportEmail,
    String? whatsappLink,
  }) {
    return GlobalConfig(
      supportEmail: supportEmail ?? this.supportEmail,
      whatsappLink: whatsappLink ?? this.whatsappLink,
    );
  }

  static GlobalConfig? empty() {
    return GlobalConfig(supportEmail: '', whatsappLink: '');
  }
}