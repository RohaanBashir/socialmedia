import 'package:social/entities/user-profile.dart';
import 'package:social/entities/user.dart';

abstract class ProfileRepo {
  Future<Map<String, dynamic>> fetchProfileData(MyUser user);
  Future<Map<String, dynamic>> updateUserProfileData(
      MyUser user, UserProfile profile);
  Future<void> subscribeToUser(String currUserId, String subscriberUserId);
  Future<void> UnsubscribeToUser(String currUserId, String UnsubscriberUserId);
}
