// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/entities/user-profile.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/profile/data/supabase_Profile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/cubit/home_cubit.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final profileRepo = SupabaseProfileRepo();
  final supabase = Supabase.instance.client;
  var issubscribed = false;
  UserProfile? currentProfile;
  MyUser? currentUser;

  ProfileCubit() : super(ProfileInitial());

  void fetchProfileData(MyUser user) async {
    try {
      emit(ProfileLoading());
      currentUser = user;
      final response = await profileRepo.fetchProfileData(currentUser!);

      currentProfile = UserProfile(
          uId: currentUser!.uId,
          name: currentUser!.name,
          email: currentUser!.email,
          description: response['description'],
          profilePicture: response['profile_picture'],
          followers: response['followers'],
          follwing: response['following']);
      emit(ProfileFetchSuccess());
    } catch (e) {
      throw Exception(ProfileError(error: e.toString()));
    }
  }

  void updateProfileData(MyUser user, UserProfile profile) async {
    try {
      emit(ProfileLoading());
      currentUser = user;
      currentProfile = profile;
      await profileRepo.updateUserProfileData(user, profile);
      emit(ProfileUpdateSuccess());
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }
  void togglesubscribeButton(){
    issubscribed = !issubscribed;
  }
  void subscribeUnsubscribeToUser(String targetUid, BuildContext context) async{

    if(issubscribed){
      emit(ProfileSubButtonPressedLoading());
      context.read<HomeCubit>().subscribedUserIds.remove(targetUid);
      await profileRepo.UnsubscribeToUser(currentUser!.uId, targetUid);
      togglesubscribeButton();
      emit(SubButtonSuccss());
    }else{
      emit(ProfileSubButtonPressedLoading());
      context.read<HomeCubit>().subscribedUserIds.add(targetUid);
      await profileRepo.subscribeToUser(currentUser!.uId, targetUid);
      togglesubscribeButton();
      emit(SubButtonSuccss());
    }
  }
}
