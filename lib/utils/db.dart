class User {
  final int id;
  final String email;
  final String password;
  final int loginTime;
  final bool loggedIn;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.loginTime,
    required this.loggedIn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'loginTime': loginTime,
      'loggedIn': loggedIn,
    };
  }
}
