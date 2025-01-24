import 'package:image_cropper/image_cropper.dart';
import 'package:social/entities/post.dart';

abstract class CreatePostRepo {
  Future<void> createPost(Post post);
  Future<String> saveImgToStore(CroppedFile image);
}
