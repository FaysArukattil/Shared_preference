import 'package:hive/hive.dart';

part 'studentmodel.g.dart';

@HiveType(typeId: 1)
class Student extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  int age;

  Student({required this.name, required this.age});
}
