// ignore_for_file: must_be_immutable

part of 'createpost_cubit.dart';

@immutable
sealed class CreatepostState {}

final class CreatepostInitial extends CreatepostState {}

final class CreatePostError extends CreatepostState {
  CreatePostError({required this.error});
  String error;
}

final class CreatePostSuccess extends CreatepostState {}

final class CreatePostLoading extends CreatepostState {

  CreatePostLoading({required this.status});
  String status;
}

final class CreatePostUiReload extends CreatepostState {}


//operation states
 final class CreatePostImageSelected extends CreatepostState{
  CreatePostImageSelected({required this.imgFile});
  CroppedFile imgFile;
 }

 final class CreatePostImgSavedToStore extends CreatepostState{

   CreatePostImgSavedToStore({required this.imgUrl});
    String imgUrl;
 }

 final class CreatePostImgSavedSuccess extends CreatepostState{}