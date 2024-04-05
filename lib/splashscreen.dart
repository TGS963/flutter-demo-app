import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'helpers.dart';
import 'main.dart';
import 'registration/registration.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAccessToken();
  }

  Future<void> checkAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? '';
    String refreshToken = prefs.getString('refreshToken') ?? '';

    final accessTokenCreationTime =
        prefs.getInt('accessTokenCreationTime') ?? 0;
    final refreshTokenCreationTime =
        prefs.getInt('refreshTokenCreationTime') ?? 0;

    final isAccessTokenExpired = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(accessTokenCreationTime),
        ) >
        const Duration(seconds: 15);

    final isRefreshTokenExpired = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(refreshTokenCreationTime),
        ) >
        const Duration(minutes: 2);

    if (accessToken == '' || refreshToken == '') {
      prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
          (Route<dynamic> route) => false,
        );
        return;
      }
    }

    if (isAccessTokenExpired && !isRefreshTokenExpired) {
      final response = await apiFetch('/auth/tokens/', refreshToken, null);
      if (response['status'] != null && response['status'] == 'success') {
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(response['message']),
          ),
        );
        await addToSharedPrefs(
          response['Authorization'][0],
          refreshToken,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (Route<dynamic> route) => false,
        );
        return;
      } else {
        prefs.clear();
        if (mounted) {
          scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Text(response['message']),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
            (Route<dynamic> route) => false,
          );
          return;
        }
      }
    } else if (isAccessTokenExpired && isRefreshTokenExpired) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text("Refresh token has been invalidated"),
        ),
      );
      prefs.clear();
      if (mounted) {
        scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text(
                "Refresh token has been invalidated. Please login or register again."),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
          (Route<dynamic> route) => false,
        );
        return;
      }
    }

    final response = await apiFetch('/auth/splashscreen/', accessToken, null);

    if (response['status'] != null && response['status'] == 'success') {
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
    } else if (response['status'] != null && response['status'] == 'error') {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      final accessTokenResponse =
          await apiFetch('/auth/tokens/', refreshToken, null);
      prefs.clear();
      if (accessTokenResponse['status'] != null &&
          accessTokenResponse['status'] == 'success') {
        await addToSharedPrefs(
          accessTokenResponse['Authorization'][0],
          refreshToken,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (Route<dynamic> route) => false,
        );
        return;
      } else {
        prefs.clear();
        if (mounted) {
          scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(
              content: Text(
                  "Refresh token has been invalidated. Please login or register again."),
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
            (Route<dynamic> route) => false,
          );
          return;
        }
      }
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
