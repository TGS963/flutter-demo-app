import 'package:flutter/material.dart';
import 'splashscreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(title: 'Demo App'),
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
