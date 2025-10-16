import 'package:donor/services/userservice.dart';
import 'package:donor/views/homescreen.dart';
import 'package:donor/views/loginscreen.dart';
import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  UserService userservice = UserService();

  @override
  void initState() {
    super.initState();
    checklogin();
  }

  Future<void> checklogin() async {
    // final pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3), () async {
      // if (pref.getString("email") != null) {
      if (await userservice.islogin() == true) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
      } else {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.bloodtype_outlined, size: 50, color: Colors.red),
            Text("Donors App", style: TextStyle(fontSize: 36)),
          ],
        ),
      ),
    );
  }
}
