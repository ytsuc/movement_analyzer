class User {
  final String id;
  final String password;
  User({required this.id, required this.password});

  Map<String, Object> toMap() {
    return {'id': id, 'password': password};
  }
}
