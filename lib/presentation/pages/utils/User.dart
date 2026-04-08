import 'Gender.dart';
import 'SportType.dart';

class User {
  // ---------- Private Fields ----------
  String _username = "";
  String _email = "";
  String _hashedPassword = "";
  int _age = 0;
  Gender _gender = Gender.male; // default to avoid null
  double _height = 0.0;
  double _weight = 0.0;
  SportType? _sportType;
  int _activeDaysPerWeek = 0;

  DateTime _firstSignInDate = DateTime.now(); // <=== NEW FIELD

  // ---------- Constructor ----------
  User({
    required String username,
    required String email,
    required String hashedPassword,
    required int age,
    required Gender gender,
    required double height,
    required double weight,
    required SportType sportType,
    required int activeDaysPerWeek,
    required DateTime firstSignInDate, // <=== NEW PARAM
  }) {
    this.username = username;
    this.email = email;
    this.hashedPassword = hashedPassword;
    this.age = age;
    this.gender = gender;
    this.height = height;
    this.weight = weight;
    this.sportType = sportType;
    this.activeDaysPerWeek = activeDaysPerWeek;
    this.firstSignInDate = firstSignInDate; // <=== NEW ASSIGNMENT
  }

  // ---------- Getters & Setters ----------

  String get username => _username;
  set username(String value) {
    if (value.isEmpty) throw Exception("Username cannot be empty.");
    _username = value;
  }

  String get email => _email;
  set email(String value) {
    if (!value.contains("@")) throw Exception("Invalid email format.");
    _email = value;
  }

  String get hashedPassword => _hashedPassword;
  set hashedPassword(String value) {
    if (value.length < 8) throw Exception("Password must be at least 8 characters.");
    _hashedPassword = value;
  }

  int get age => _age;
  set age(int value) {
    if (value <= 0 || value >= 120) {
      throw Exception("Age must be between 1 and 119.");
    }
    _age = value;
  }

  Gender get gender => _gender;
  set gender(Gender value) {
    _gender = value;
  }

  double get height => _height;
  set height(double value) {
    if (value < 50 || value > 250) {
      throw Exception("Height must be between 50 cm and 250 cm.");
    }
    _height = value;
  }

  double get weight => _weight;
  set weight(double value) {
    if (value < 10 || value > 400) {
      throw Exception("Weight must be between 10 kg and 400 kg.");
    }
    _weight = value;
  }

  SportType get sportType => _sportType!;
  set sportType(SportType value) {
    _sportType = value;
  }

  int get activeDaysPerWeek => _activeDaysPerWeek;
  set activeDaysPerWeek(int value) {
    if (value < 0 || value > 7) {
      throw Exception("Active days per week must be between 0 and 7.");
    }
    _activeDaysPerWeek = value;
  }

  // ---------- First Sign In Date ----------
  DateTime get firstSignInDate => _firstSignInDate;
  set firstSignInDate(DateTime value) {
    _firstSignInDate = value;
  }

  // ---------- Load from JSON ----------
  void loadUserFromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    hashedPassword = json['hashedPassword'];
    age = json['age'];

    gender = Gender.values.firstWhere(
          (e) => e.toString() == 'Gender.' + json['gender'],
    );

    height = json['height'];
    weight = json['weight'];

    sportType = SportType.values.firstWhere(
          (e) => e.toString() == 'SportType.' + json['sportType'],
    );

    activeDaysPerWeek = json['activeDaysPerWeek'];

    firstSignInDate = DateTime.parse(json['firstSignInDate']); // <=== NEW JSON FIELD
  }
}
