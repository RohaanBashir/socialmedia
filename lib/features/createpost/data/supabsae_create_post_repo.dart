import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:social/entities/post.dart';
import 'package:social/features/createpost/repository/create_post_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabsaeCreatePostRepo extends CreatePostRepo {
  final supabase = Supabase.instance.client;
  @override
  Future<void> createPost(Post post) async {
    try {
      await supabase.from('posts').insert({
        'uid': post.postUser!.uId,
        'postid': post.postId,
        'likes': post.likes,
        'postdescription': post.postDescription,
        'img': post.img,
        'comments': post.comments
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> saveImgToStore(CroppedFile image) async {
    try {
      final file = File(image.path);
      final fileName =
          'posts/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      await supabase.storage.from('posts').upload(fileName, file);
      final imageUrl = supabase.storage.from('posts').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
