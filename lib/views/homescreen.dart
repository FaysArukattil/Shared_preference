import 'package:donor/models/user.dart';
import 'package:donor/services/db_helper.dart';
import 'package:donor/services/userservice.dart';
import 'package:donor/views/adduser.dart';
import 'package:donor/views/loginscreen.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  DatabaseHelper dbhelper = DatabaseHelper();
  UserService userservice = UserService();
  String email = "";

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    email = (await userservice.getemail())!; // ✅ properly called
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Logout please")));
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUser()),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.black,
          title: Text("Hi $email"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.power_settings_new_rounded),
              onPressed: () async {
                userservice.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginscreen()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: dbhelper.getall(),
          builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("No Data"));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var user = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(child: Text("${user["ID"]}")),
                      title: Text("${user["NAME"]}"),
                      subtitle: Text("${user["PHONE"]}"),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                // ✅ Fill controllers with existing values
                                nameController.text = user["NAME"];
                                ageController.text = user["AGE"].toString();
                                phoneController.text = user["PHONE"];
                                emailController.text = user["EMAIL"];

                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Edit User"),
                                      content: SingleChildScrollView(
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: nameController,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: "Name",
                                                    ),
                                                validator: (v) {
                                                  return (v == null ||
                                                          v.trim().isEmpty)
                                                      ? "Must fill"
                                                      : null;
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              TextFormField(
                                                controller: ageController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: "Age",
                                                    ),
                                                validator: (v) {
                                                  return (v == null ||
                                                          v.trim().isEmpty)
                                                      ? "Must fill"
                                                      : null;
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              TextFormField(
                                                controller: phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: "Phone",
                                                    ),
                                                validator: (v) {
                                                  return (v == null ||
                                                          v.trim().isEmpty)
                                                      ? "Must fill"
                                                      : null;
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              TextFormField(
                                                controller: emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: "Email",
                                                    ),
                                                validator: (v) {
                                                  return (v == null ||
                                                          v.trim().isEmpty)
                                                      ? "Must fill"
                                                      : null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // ✅ Create a User object and update directly
                                              User updatedUser = User(
                                                ID: user["ID"],
                                                NAME: nameController.text
                                                    .trim(),
                                                AGE: int.parse(
                                                  ageController.text.trim(),
                                                ),
                                                PHONE: phoneController.text
                                                    .trim(),
                                                EMAIL: emailController.text
                                                    .trim(),
                                              );

                                              await dbhelper.editUser(
                                                updatedUser.ID!,
                                                updatedUser.tomap(),
                                              );

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(
                                                // ignore: use_build_context_synchronously
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                    "User Updated Successfully",
                                                  ),
                                                ),
                                              );

                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              setState(() {});
                                            }
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await dbhelper.deleteUser(user["ID"]);
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Deleted Successfully"),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
