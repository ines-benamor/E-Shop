class User {
  final String username;
  final String uid;
  final String email;
  final String name;
  final String surname;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.name,
    required this.surname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      uid: json["uid"],
      email: json["email"],
      name: json["name"],
      surname: json["surname"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "name": name,
        "surname": surname,
      };
}
