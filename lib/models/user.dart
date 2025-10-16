// ignore_for_file: non_constant_identifier_names

class User {
  int? ID;
  late int AGE;
  late String NAME, PHONE, EMAIL;
  User({
    this.ID,
    required this.AGE,
    required this.NAME,
    required this.EMAIL,
    required this.PHONE,
  });

  Map<String, dynamic> tomap() {
    return {"NAME": NAME, "AGE": AGE, "EMAIL": EMAIL, "PHONE": PHONE};
  }
}
