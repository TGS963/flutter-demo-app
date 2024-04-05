import 'package:demo_project/helpers.dart';
import 'package:flutter/material.dart';
import '../dashboard.dart';
import '../main.dart';

class MySignupPage extends StatefulWidget {
  const MySignupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPage();
}

class _MySignupPage extends State<MySignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _signup(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final response = await apiFetch('/user/register', '', {
      'email': _emailController.text,
      'password': _passwordController.text,
      'username': _usernameController.text,
    });
    setState(() {
      isLoading = false;
    });

    if (response['status'] != null && response['status'] == 'error') {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      return;
    } else if (response['status'] != null && response['status'] == 'success') {
      await addToSharedPrefs(
          response['Authorization'][0], response['Authorization'][1]);
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (Route<dynamic> route) => false,
      );
      return;
    }
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
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
              ),
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
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
