import 'package:social/entities/user.dart';

class Post {
  MyUser? postUser;
  String? postId;
  String? postDescription;
  int likes;
  String? img;
  List<String> comments = List.filled(1, "", growable: true);
  String? date;

  Post({
    this.postUser,
    this.postId,
    this.postDescription,
    this.likes = 0,
    this.img,
    this.date,
  });
}
