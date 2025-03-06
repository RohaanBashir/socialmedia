
import '../../../entities/post.dart';
import '../../../entities/user-profile.dart';
import '../../../entities/user.dart';

abstract class HomePageRepo{

  Future<List<Map<String, dynamic>>> fetchPosts ();
  Future<List<Map<String,dynamic>>> fetchUsers();
  Future<UserProfile> getUserProfile(MyUser user);

}