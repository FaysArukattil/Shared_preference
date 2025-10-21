import 'package:donor/models/studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Studentpage extends StatefulWidget {
  const Studentpage({super.key});

  @override
  State<Studentpage> createState() => _StudentpageState();
}

class _StudentpageState extends State<Studentpage> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late Box<Student> studentBox;
  @override
  void initState() {
    super.initState();
    studentBox = Hive.box<Student>("studentBox");
  }

  void addStudent() {
    final namedata = name.text.trim();
    final agedata = int.parse(age.text.trim());
    if (agedata > 0) {
      Student student = Student(name: namedata, age: agedata);
      studentBox.add(student);
      name.clear();
      age.clear();
      setState(() {});
    }
  }

  void delete(int index) {
    studentBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: name,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) {
                return v == null ? "must fill" : null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: age,

              decoration: InputDecoration(
                labelText: 'Age',
                prefixIcon: const Icon(Icons.calendar_month),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) {
                return v == null ? "must fill" : null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    addStudent();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                child: ValueListenableBuilder(
                  valueListenable: studentBox.listenable(),
                  builder:
                      (
                        BuildContext context,
                        Box<Student> value,
                        Widget? child,
                      ) {
                        if (value.isEmpty) {
                          return Center(child: Text("No data found"));
                        } else {
                          return ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (BuildContext context, int index) {
                              final student = value.getAt(index);
                              return ListTile(
                                title: Text(student!.name),
                                subtitle: Text("${student.age}"),
                                trailing: IconButton(
                                  onPressed: () {
                                    delete(index);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              );
                            },
                          );
                        }
                      },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
