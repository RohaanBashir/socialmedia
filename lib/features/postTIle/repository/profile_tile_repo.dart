
import '../../../entities/post.dart';

abstract class ProfileTileRepository{

  Future<void> addLikeToPost(Post post, String currUserId);
  Future<void> removeLikeToPost(Post post, String currUserId);

}