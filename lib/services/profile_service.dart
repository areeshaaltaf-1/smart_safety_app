import 'package:hive/hive.dart';

class ProfileService {

  static final box = Hive.box('userBox');

  static void saveProfile(Map data) {
    box.put("profile", data);
  }

  static Map getProfile() {
    return box.get("profile", defaultValue: {});
  }

  static bool isVerifiedUser() {
    final data = getProfile();
    return data["isVerified"] ?? false;
  }
}