enum UserRole {
  photographer,
  client,
  admin;

  static UserRole fromString(String value) =>
      values.firstWhere((e) => e.name == value);
}
