class User {
  final String id;
  final String email;
  final String password;
  final int loginTime;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.loginTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'loginTime': loginTime,
    };
  }
}
