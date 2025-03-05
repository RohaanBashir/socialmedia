
import '../../../entities/post.dart';

abstract class HomePageRepo{

  Future<List<Map<String, dynamic>>> fetchPosts ();
}