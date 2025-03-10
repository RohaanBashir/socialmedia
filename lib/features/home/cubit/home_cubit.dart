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

  Future<void> fetchPosts(List<String> ids) async {
    try {
      emit(HomeLoading());
      final posts = <Post>[];
      final response = await homerepo.fetchPosts(ids);

      for (final postData in response) {
        try {
          final tempUser = postData['user'] as Map<String, dynamic>;
          final postUser = MyUser(
            tempUser['name'] as String,
            tempUser['email'] as String,
            tempUser['uid'] as String,
          );

          // Handle possible null values for arrays
          final rawComments = postData['comments'] as List<dynamic>? ?? [];
          final rawLikes = postData['likes'] as List<dynamic>? ?? [];

          // Safe type conversion
          final comments = rawComments.map((e) => e.toString()).toList();
          final likes = rawLikes.map((e) => e.toString()).toList();

          final post = Post(
            postUser: postUser,
            postId: postData['postid'] as String,
            postDescription: postData['postdescription'] as String,
            img: postData['img'] as String?, // Initialize directly in constructor
          );

          for (final comment in comments) {
            post.comments.add(comment);
          }
          for(final like in likes){
            post.likes.add(like);
          }
          // Handle date parsing safely
          if (postData['created_at'] != null) {
            post.storeDateTimeFromString(postData['created_at'].toString());
          }

          posts.add(post);
        } catch (e) {
          print('Error processing post: $e');
        }
      }

      emit(HomeFetchUserPostsSuccess(post: posts));
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
