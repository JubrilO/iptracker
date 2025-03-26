class IPData {
  final String ipAddress;
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;
  
  IPData({
    required this.ipAddress,
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
  });
  
  factory IPData.fromJson(Map<String, dynamic> json) {
    return IPData(
      ipAddress: json['ip'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      city: json['city'],
      country: json['country_name'],
    );
  }
}