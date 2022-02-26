import 'package:shared_preferences/shared_preferences.dart';

class CommonUserService {
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    return accessToken != null && accessToken != "";
  }
}
