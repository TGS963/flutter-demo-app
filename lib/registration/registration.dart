import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intro Page'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyLoginPage(title: "Login Page"),
                        ),
                      )
                    },
                child: Text("Login")),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MySignupPage(title: "Signup Page"),
                        ),
                      )
                    },
                child: Text("Signup"))
          ],
        ),
      ),
    );
  }
}
