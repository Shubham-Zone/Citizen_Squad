class User {
  final String name, email, password;

  User({required this.name, required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json["name"], email: json["email"], password: json["password"]);

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
  };
}