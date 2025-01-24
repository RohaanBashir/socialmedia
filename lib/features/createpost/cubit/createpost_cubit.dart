// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/entities/post.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/createpost/data/supabsae_create_post_repo.dart';
import 'package:social/features/createpost/repository/create_post_repo.dart';
import 'package:uuid/uuid.dart';

part 'createpost_state.dart';

class CreatepostCubit extends Cubit<CreatepostState> {
  CreatepostCubit() : super(CreatepostInitial());
  CreatePostRepo createpost = SupabsaeCreatePostRepo();

  void createPost(String description, String img, MyUser currentuser) async {
    try {
      emit(CreatePostLoading(status: "Saving into Database"));
      final post = Post(
          postUser: currentuser,
          postId: generatePostId(),
          postDescription: description,
          img: img);
      await createpost.createPost(post);
      emit(CreatePostImgSavedSuccess());

    } catch (e) {
        emit(CreatePostError(error: e.toString()));
    }
  }
  void selectImgFromDevice() async {
    try{
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      CroppedFile? file = await cropImage(image!);
      emit(CreatePostImageSelected(imgFile: file!));
    }
    catch(e){
      emit(CreatePostError(error: e.toString()));
    }
  }

  Future<CroppedFile?> cropImage(XFile img) async {

    CroppedFile? croppedFile;
    if (File(img.path).existsSync()) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),

        uiSettings: [
          AndroidUiSettings(
            activeControlsWidgetColor: AppColors.secondaryColor,
            toolbarTitle: 'Adjust Image',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: AppColors.secondaryColor,
            hideBottomControls: false,
            lockAspectRatio: true, // Locks the crop aspect ratio
          ),
        ],
      );
    }
    else{
      throw Exception("Cant read the image");
    }
    return croppedFile;
  }

  Future<String?> saveImgToStore(CroppedFile img) async {
    try {
      emit(CreatePostLoading(status: "Saving to Storage"));
      String url = await createpost.saveImgToStore(img);
      return url;
    } catch (e) {
      return null;
    }
  }
  String generatePostId() {
    var uuid = Uuid();
    return uuid.v4();
  }
}
