// ==================== models/user_model.dart ====================
class UserModel {
  final int? userId;
  final String username;
  final String email;
  final String hashedPassword;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String sportType;
  final int activeDaysPerWeek;
  final String firstSignInDate;

  UserModel({
    this.userId,
    required this.username,
    required this.email,
    required this.hashedPassword,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.sportType,
    required this.activeDaysPerWeek,
    required this.firstSignInDate,
  });

  // Convert model to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      if (userId != null) 'user_id': userId,
      'username': username,
      'email': email,
      'hashed_password': hashedPassword,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'sport_type': sportType,
      'active_days_per_week': activeDaysPerWeek,
      'first_sign_in_date': firstSignInDate,
    };
  }

  // Create model from database Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      hashedPassword: map['hashed_password'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      sportType: map['sport_type'] as String,
      activeDaysPerWeek: map['active_days_per_week'] as int,
      firstSignInDate: map['first_sign_in_date'] as String,
    );
  }

  // Create a copy with modified fields
  UserModel copyWith({
    int? userId,
    String? username,
    String? email,
    String? hashedPassword,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? sportType,
    int? activeDaysPerWeek,
    String? firstSignInDate,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      sportType: sportType ?? this.sportType,
      activeDaysPerWeek: activeDaysPerWeek ?? this.activeDaysPerWeek,
      firstSignInDate: firstSignInDate ?? this.firstSignInDate,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, username: $username, email: $email)';
  }
}
