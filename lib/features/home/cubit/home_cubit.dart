// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/auth/data/supabase-auth-repo.dart';
import 'package:social/features/auth/repository/authRepo.dart';
import 'package:social/features/home/data/supabase_home_page_repo.dart';
import 'package:social/features/home/repository/home_page_repo.dart';

import '../../../entities/post.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Post> posts = [];
  AuthRepo authrepo = SupabaseAuthRepo();
  HomePageRepo homerepo = SupabaseHomeRepo();

  void signOut() async {
    try {
      emit(HomeLoading());
      await authrepo.signOut();
      emit(SignoutSucess());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void fetchPosts() async {
    try {
      final response = await homerepo.fetchPosts();
      //loop iterating over the list
      for (int i = 0; i < response.length; i++) {
        var tempResponse = response[i];
        Map<String, dynamic> tempUser = tempResponse['user'];
        print(tempUser);
        MyUser postUser = MyUser(tempUser['name'], tempUser['email'], tempUser['uid']);
        print(postUser);
        posts.add(Post(
          postUser: postUser,
          postId: tempResponse['postid'],
          postDescription: tempResponse['postdescription'],
          likes: tempResponse['likes'],
          img: tempResponse['img'],));
        posts[i].storeDateTimeFromString(tempResponse['created_at']);
        //assigning comments
        List<dynamic> tempComments = tempResponse['comments'];
        List<String> comments = tempComments.cast<String>();
          for (int j = 0; j < comments.length; j++) {
            posts[i].comments[j] = comments[j];
          }
          print(posts[i]);
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
