class Movement {
  final String userId;
  final double longitude;
  final double latitude;
  final double acceleration;
  final DateTime timestamp;

  Movement(
      {required this.userId,
      required this.longitude,
      required this.latitude,
      required this.acceleration,
      required this.timestamp});

  Map<String, Object> toMap() {
    return {
      'user_id': userId,
      'longitude': longitude,
      'latitude': latitude,
      'acceleration': acceleration,
      'recorded_at': timestamp.toString()
    };
  }
}
