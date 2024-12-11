class User {
  int id;
  String name;
  String token;

  User({
    required this.id,
    required this.name,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      token: json['token'],
    );
  }
}
