import 'package:social/entities/user-profile.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/profile/repository/profile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileRepo extends ProfileRepo {
  final supabase = Supabase.instance.client;
  @override
  Future<Map<String, dynamic>> fetchProfileData(MyUser user) async {
    try {
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('uid', user.uId)
          .single();
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserProfileData(
      MyUser user, UserProfile profile) async {
    try {
      final response = await supabase.from('user_profile').insert({
        'uid': profile.uId,
        'profile_picture': profile.profilePicture,
        'followers': profile.followers,
        'following': profile.follwing,
        'description': profile.description
      });
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
