import 'package:social/features/home/repository/home_page_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../entities/post.dart';

class SupabaseHomeRepo implements HomePageRepo{

  final supabase = Supabase.instance.client;
  @override
  Future<List<Map<String, dynamic>>> fetchPosts() async{
    try{
      final response = await supabase
          .from('posts')
          .select('''
          postid,postdescription, img, likes, comments, created_at, user:uid (name, email,uid)
        ''')
          .order('created_at', ascending: false);
      print(response);
      return response;
    }catch(e){
      throw Exception(e);
    }

  }
}