class User {
  int id;
  String user_id;
  String name;
  String surname;
  String title;

  User(
      {required this.id,
      required this.name,
      required this.surname,
      required this.user_id,
      required this.title});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        user_id: json["userId"] as String,
        id: json["id"] as int,
        name: json["title"] as String,
        surname: json["body"] as String,
        title: json["title"] as String);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "user_id": user_id,
        "title": title,
      };
}
