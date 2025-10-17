import 'package:donor/services/db_helper.dart';
import 'package:donor/services/userservice.dart';
import 'package:donor/views/adduser.dart';
import 'package:donor/views/loginscreen.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DatabaseHelper dbhelper = DatabaseHelper();
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUser()),
          ),
        ),
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
        body: FutureBuilder(
          future: dbhelper.getall(),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text("No Data"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var user = snapshot.data![index];
                        return ListTile(
                          leading: CircleAvatar(child: Text("${user["ID"]}")),
                          title: Text("${user["NAME"]}"),
                          subtitle: Text("${user["PHONE"]}"),
                          trailing: IconButton(
                            onPressed: () async {
                              await dbhelper.deleteUser(user["ID"]).then((
                                value,
                              ) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Deleted Succesfully"),
                                  ),
                                );
                                setState(() {});
                              });
                              {
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error:${snapshot.error}"));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
        ),
      ),
    );
  }
}
