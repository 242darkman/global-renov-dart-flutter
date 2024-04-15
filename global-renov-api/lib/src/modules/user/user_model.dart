class User {
  String? id;
  String email;
  String password;
  String firstName;
  String lastName;

  User(
      {this.id,
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});

  String get getEmail => email;

  String get getPassword => password;

  String get getFirstName => firstName;

  String get getLastName => lastName;
}
