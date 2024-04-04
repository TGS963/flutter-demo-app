import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, you're logged in as $email"),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MySplashScreen(title: "Intro Page"),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
