import 'package:demo_project/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'dashboard.dart';
import 'registration/registration.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginTime();
  }

  Future<void> checkLoginTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';

    // get login time from db
    final users = await getUsers();
    final user = users.firstWhereOrNull((user) => user.email == email);

    final loginTime = user?.loginTime;

    if (loginTime != null && user != null) {
      var now = DateTime.now().millisecondsSinceEpoch;
      var thirtySeconds = 30 * 1000; //10 seconds
      updateUserLoginTime(user.id, now);
      if ((now - loginTime < thirtySeconds) && email != '') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    email: prefs.getString('email')!,
                  )),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Demo App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
