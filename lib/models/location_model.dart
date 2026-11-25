class LocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? countryCode;
  final String? admin1;
  final String? timezone;

  LocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.countryCode,
    this.admin1,
    this.timezone,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'country_code': countryCode,
      'admin1': admin1,
      'timezone': timezone,
    };
  }

  String get subtitle {
    final parts = <String>[];
    if (admin1 != null && admin1!.isNotEmpty) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  String get fullDisplayName {
    if (subtitle.isEmpty) return name;
    return '$name, $subtitle';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => id.hashCode ^ latitude.hashCode ^ longitude.hashCode;

  /// Lokasi default untuk Jakarta (Indonesia) saat aplikasi pertama kali dibuka
  static LocationModel get defaultLocation => LocationModel(
        id: 1642911,
        name: 'Jakarta',
        latitude: -6.21462,
        longitude: 106.84513,
        country: 'Indonesia',
        countryCode: 'ID',
        admin1: 'DKI Jakarta',
        timezone: 'Asia/Jakarta',
      );
}
