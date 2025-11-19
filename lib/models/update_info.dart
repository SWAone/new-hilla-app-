/// Model for app update information from API
class UpdateInfo {
  final String minimumVersion;
  final String latestVersion;
  final bool forceUpdate;
  final String androidStoreLink;
  final String iosStoreLink;
  final String? updateMessage;

  UpdateInfo({
    required this.minimumVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.androidStoreLink,
    required this.iosStoreLink,
    this.updateMessage,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      minimumVersion: json['minimumVersion'] as String? ?? '1.0.0',
      latestVersion: json['latestVersion'] as String? ?? '1.0.0',
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      androidStoreLink: json['androidStoreLink'] as String? ?? '',
      iosStoreLink: json['iosStoreLink'] as String? ?? '',
      updateMessage: json['updateMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimumVersion': minimumVersion,
      'latestVersion': latestVersion,
      'forceUpdate': forceUpdate,
      'androidStoreLink': androidStoreLink,
      'iosStoreLink': iosStoreLink,
      'updateMessage': updateMessage,
    };
  }
}



