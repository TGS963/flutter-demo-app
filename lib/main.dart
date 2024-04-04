import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dashboard.dart';

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyIntroPage(title: 'Demo App'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPage();
}

class MySignupPage extends StatefulWidget {
  const MySignupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MySignupPage> createState() => _MySignupPage();
}

class MyIntroPage extends StatefulWidget {
  const MyIntroPage({Key? key, required this.title});
  final String title;

  @override
  _MyIntroPageState createState() => _MyIntroPageState();
}

class _MyIntroPageState extends State<MyIntroPage> {
  @override
  void initState() {
    super.initState();
    checkLoginTime();
  }

  Future<void> checkLoginTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? loginTime = prefs.getInt('loginTime');
    String email = prefs.getString('email') ?? '';

    if (loginTime != null) {
      var now = DateTime.now().millisecondsSinceEpoch;
      var twoMinutes = 30 * 1000; //10 seconds
      if ((now - loginTime < twoMinutes) && email != '') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    email: prefs.getString('email')!,
                  )),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

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

class _MyLoginPage extends State<MyLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('email');
    final password = prefs.getString('password');
    prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);

    if (_emailController.text == username &&
        hashPassword(_passwordController.text) == password) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard(email: username!)),
        (Route<dynamic> route) => false, // Never go back
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')));
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      _login(context);
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

class _MySignupPage extends State<MySignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signup(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', hashPassword(_passwordController.text));
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
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

void main() {
  runApp(const MyApp());
}
 
//  In the above code, we have created a simple login form with two fields email and password. We have used the  TextFormField  widget to create the input fields. We have also used the  Form  widget to wrap the input fields. 
//  The  Form  widget has a  key  property that is used to uniquely identify the form. We have used the  GlobalKey  class to create a global key for the form. 
//  The  TextFormField  widget has a  validator  property that is used to validate the input field. We have used the  validator  property to check if the input field is empty or not. 
//  When the user clicks on the submit button, we have checked if the form is valid or not using the  validate()  method. If the form is valid, we have shown a snackbar message. 
//  Conclusion 
//  In this article, we have learned how to validate a form in Flutter. We have seen how to use the  Form  widget and the  TextFormField  widget to create a form with validation. We have also seen how to use the  GlobalKey  class to create a global key for the form. 
//  Thanks for reading! 
//  #flutter #dart #mobile-apps  
//  What is GEEK
//  Buddha Community
//  Google's Flutter 1.20 stable announced with new features - Navoki
//  Flutter Google cross-platform UI framework has released a new version 1.20 stable. 
//  Flutter is Google’s UI framework to make apps for Android, iOS, Web, Windows, Mac, Linux, and  Fuchsia OS. Since the last 2 years, the flutter Framework has already achieved popularity among mobile developers to develop Android and iOS apps. In the last few releases, Flutter also added the support of making  web applications and  desktop applications. 
//  Last month they introduced the support of the Linux desktop app that can be distributed through Canonical  Snap Store(Snapcraft), this enables the developers to publish there Linux desktop app for their users and publish on  Snap Store.  If you want to learn how to  Publish Flutter Desktop app in Snap Store that here is the tutorial. 
//  Flutter 1.20 Framework is built on Google’s made  Dart programming language that is a cross-platform language providing native performance, new UI widgets, and other more features for the developer usage. 
//  Here are the few key points of this release: 
//  Performance improvements for Flutter and Dart 
//  In
