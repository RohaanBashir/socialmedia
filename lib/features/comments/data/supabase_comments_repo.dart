

import 'package:social/features/comments/repository/comment_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCommentsRepo extends CommentsPageRepo{
  @override
  Future<void> sendComment(String comment, String postId) async {

    try{
      await Supabase.instance.client
          .rpc('add_comment_to_post', params: {
        'post_id': postId,
        'comment': comment});
    }catch(e){
      throw Exception(e.toString());
    }
  }
  @override
  Future<List<Map<String, dynamic>>> fetchComments(String postId)async{
    try{
      final response = await Supabase.instance.client.from('posts').select('comments').eq('postid', postId);
      return response;
    }catch(e){
      throw Exception(e.toString());
    }
  }
}