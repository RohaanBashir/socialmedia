import 'package:social/entities/user-profile.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/home/repository/home_page_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../entities/post.dart';

class SupabaseHomeRepo implements HomePageRepo {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> fetchPosts(List<String> subscribedUserIds) async {
    try {
      final response = await supabase
          .from('posts')
          .select('''
      postid, postdescription, img, likes, comments, created_at, user:uid (name, email, uid)
    ''').inFilter('uid', subscribedUserIds)
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
  @override
  Future<List<Map<String, dynamic>>> fetchUsers() {
    try {
      final response = supabase.from('user').select(''' uid , name , email ''');
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserProfile> getUserProfile(MyUser user) async {
    try {
      final response = await supabase
          .from('user_profile')
          .select('''user:uid(uid,name,email) , profile_picture, followers, following, description''').eq(
              'uid', user.uId);
      var tempuser = response[0]['user'];
      final profile = UserProfile(
        uId: tempuser['uid'],
        name: tempuser['name'],
        email: tempuser['email'],
        profilePicture: response[0]['profile_picture'],
        followers: response[0]['followers'],
        follwing: response[0]['following'],
        description: response[0]['description'],
      );
      return profile;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<String>> fetchSubscribedofCurrentUser(String curentUserId) async {
    try {
      final response = await supabase
          .from('subscriber')
          .select('subed_uid')
          .eq('uid', curentUserId);
      List<String> subscribedUserIds =
          response.map((item) => item['subed_uid'] as String).toList();
      return subscribedUserIds;
    } catch (e) {
      throw Exception(e);
    }
  }
}
