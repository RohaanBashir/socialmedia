// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/editprofile/data/supabase_edit_profile_repo.dart';

part 'editprofile_state.dart';

class EditprofileCubit extends Cubit<EditprofileState> {
  final editProfileRepo = SupabaseEditProfileRepo();
  String? currentImage;
  String? tempImage;
  String? currDescription;

  EditprofileCubit() : super(EditprofileInitial());

  void upLoad(MyUser currentuser, String profileimg, String description) async {
    try {
      if (currDescription != description && currentImage != tempImage) {
        emit(EditLoading(status: "Saving Profile..."));
        await editProfileRepo.updateDescription(currentuser, description);
        currDescription = description;
        await editProfileRepo.uploadImage(currentuser, tempImage!);
        currentImage = tempImage;
        emit(EditUploadSuccess(
            url: currentImage!, description: currDescription!));
      }

      if (currDescription != description) {
        emit(EditLoading(status: "Saving Description..."));
        await editProfileRepo.updateDescription(currentuser, description);
        currDescription = description;
        emit(EditUploadSuccess(
            url: currentImage!, description: currDescription!));
      }
      if (currentImage != tempImage) {
        emit(EditLoading(status: "Saving Profile Picture..."));
        await editProfileRepo.uploadImage(currentuser, tempImage!);
        currentImage = tempImage;
        emit(EditUploadSuccess(
            url: currentImage!, description: currDescription!));
      }
    } catch (e) {
      emit(EditError(error: e.toString()));
    }
  }

  void updateCurrentImage() async {
    try {
      XFile? file = await editProfileRepo.getImageFromGalery();
      if (file != null) {
        emit(EditLoading(status: "Please wait, loading image..."));
        String imgurl = await editProfileRepo.updateCurrentImage(file);
        tempImage = imgurl;
        emit(EditUpdateImgageSuccess(url: imgurl));
      }
    } catch (e) {
      emit(EditError(error: e.toString()));
    }
  }
}
