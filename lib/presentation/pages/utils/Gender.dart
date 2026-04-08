enum Gender {
 male,
  female
}
Gender genderFromString(String? value) {
 return Gender.values.firstWhere(
      (g) => g.name.toLowerCase() == value!.toLowerCase(),
  orElse: () => Gender.male, // default if value doesn’t match
 );
}
