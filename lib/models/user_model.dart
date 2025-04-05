class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? token;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      token: token,
    );
  }
}
