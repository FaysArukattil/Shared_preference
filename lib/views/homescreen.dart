import 'package:donor/services/userservice.dart';
import 'package:donor/views/loginscreen.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  UserService userservice = UserService();
  String email = "";
  @override
  void initState() {
    getdata();
    super.initState();
  }

  Future<void> getdata() async {
    // final pref = await SharedPreferences.getInstance();
    // email = pref.getString("email") ?? "Not available";
    userservice.getemail;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Logout please")));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.black,
          title: Text("Hi $email"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.power_settings_new_rounded),
              onPressed: () async {
                // final pref = await SharedPreferences.getInstance();
                // pref.clear();
                userservice.logout();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => Loginscreen()),
                );
              },
            ),
          ],
        ),
        body: Column(),
      ),
    );
  }
}
