
abstract class CommentsPageRepo{

  Future<void> sendComment(String comment, String postId);
  Future<List<Map<String,dynamic>>> fetchComments(String postId);
}