import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final String _emailkey = "email";
  static final String _passwordkey = "password";
  static final String _isloginkey = "is_login";

  Future<void> saveusercredentials({
    required String email,
    required String pass,
  }) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_emailkey, email);
    pref.setString(_passwordkey, pass);
    pref.setBool(_isloginkey, true);
  }

  Future<String?> getemail() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(_emailkey)) {
      return pref.getString(_emailkey);
    }
    return null;
  }

  Future<bool?> islogin() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(_isloginkey)) {
      return pref.getBool(_isloginkey);
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(_isloginkey);
    pref.remove(_emailkey);
    pref.remove(_passwordkey);
    pref.clear();
  }
}
