
import 'package:social/entities/post.dart';
import 'package:social/features/postTIle/repository/profile_tile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileTileRepo extends ProfileTileRepository{


  final supabase = Supabase.instance.client;
  @override
  Future<void> addLikeToPost(Post post, String currUserId) async {
    try{
      final response =  await supabase
          .rpc('add_uid_to_likes', params: {
        'post_id': post.postId,
        'user_id': currUserId,
      });
      print(response);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> removeLikeToPost(Post post, String currUserId ) async {
    try{
      final res = await supabase
          .rpc('remove_uid_from_likes', params: {
        'post_id': post.postId,
        'user_id': currUserId,
      });
      print(res);

    }catch(e){
      throw Exception(e.toString());
    }
  }


}