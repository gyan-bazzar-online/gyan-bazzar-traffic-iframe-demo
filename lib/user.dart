class User {
  String name;
  String mobile_number;

  User({
    required this.name,
    required this.mobile_number,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      mobile_number: json['mobile_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile_number': mobile_number,
    };
  }
}
