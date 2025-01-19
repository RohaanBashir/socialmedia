import 'package:social/entities/user-profile.dart';
import 'package:social/entities/user.dart';

abstract class ProfileRepo {
  Future<Map<String, dynamic>> fetchProfileData(MyUser user);
  Future<Map<String, dynamic>> updateUserProfileData(
      MyUser user, UserProfile profile);
}
