enum SportType {
  soccer,
  basketball,
  tennis,
  baseball,
  football,
  hockey,
  volleyball,
  cricket,
  rugby,
  swimming;

  /// Convert a string to a SportType enum
  static SportType fromString(String value) {
    return SportType.values.firstWhere(
          (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
      orElse: () => SportType.football, // default if string doesn't match
    );
  }

  /// Optional: convert enum to string (without the enum prefix)
  String get name => toString().split('.').last;
}
