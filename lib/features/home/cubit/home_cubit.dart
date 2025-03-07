// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/entities/user-profile.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/data/supabase-auth-repo.dart';
import 'package:social/features/auth/repository/authRepo.dart';
import 'package:social/features/home/data/supabase_home_page_repo.dart';
import 'package:social/features/home/repository/home_page_repo.dart';

import '../../../entities/post.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<MyUser> users = [];
  List<String> subscribedUserIds = [];
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

  Future<void> fetchUsers() async {
    try {
      final response = await homerepo.fetchUsers();
      for (int i = 0; i < response.length; i++) {
        var tempResponse = response[i];
        users.add(MyUser(
            tempResponse['name'], tempResponse['email'], tempResponse['uid']));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> fetchPosts() async {
    try {
      emit(HomeLoading());
      final posts = <Post>[];
      final response = await homerepo.fetchPosts(subscribedUserIds);
      //loop iterating over the list
      for (int i = 0; i < response.length; i++) {
        var tempResponse = response[i];
        Map<String, dynamic> tempUser = tempResponse['user'];
        MyUser postUser =
            MyUser(tempUser['name'], tempUser['email'], tempUser['uid']);
        posts.add(Post(
          postUser: postUser,
          postId: tempResponse['postid'],
          postDescription: tempResponse['postdescription'],
          likes: tempResponse['likes'],
          img: tempResponse['img'],
        ));
        posts[i].storeDateTimeFromString(tempResponse['created_at']);
        //assigning comments
        List<dynamic> tempComments = tempResponse['comments'];
        List<String> comments = tempComments.cast<String>();
        for (int j = 0; j < comments.length; j++) {
          posts[i].comments[j] = comments[j];
        }
        emit(HomeFetchUserPostsSuccess(post: posts));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<UserProfile> returnUserProfile(MyUser user) async {
    final response = await homerepo.getUserProfile(user);
    return response;
  }

  Future<void> fetchUserSubscribedIds(String UserId) async {
    try {
      subscribedUserIds =
          await homerepo.fetchSubscribedofCurrentUser(UserId) as List<String>;
    } catch (e) {
      emit(HomeError(e.toString()));
      rethrow;
    }
  }
}
