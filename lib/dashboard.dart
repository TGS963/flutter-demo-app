import 'main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            Text("Welcome $email"),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');
                  prefs.remove('password');
                  prefs.remove('loginTime');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyIntroPage(title: "Intro Page"),
                    ),
                  );
                },
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
