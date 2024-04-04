import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/db.dart';
import '../utils/helpers.dart';

class MySignupPage extends StatefulWidget {
  const MySignupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPage();
}

class _MySignupPage extends State<MySignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var uuid = Uuid();

  Future<void> _signup(BuildContext context) async {
    final newUser = User(
      id: uuid.v4(),
      email: _emailController.text,
      password: hashPassword(_passwordController.text),
      loginTime: DateTime.now().millisecondsSinceEpoch,
    );

    await insertUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup successful! Please login to continue.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signup(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
