import 'package:image_picker/image_picker.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/editprofile/repository/edit_profile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEditProfileRepo extends EditProfileRepo {
  final supabase = Supabase.instance.client;

  @override
  Future<void> updateDescription(MyUser currentUser, String description) async {
    try {
      await supabase
          .from('user_profile')
          .update({'description': description}).eq('uid', currentUser.uId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> uploadImage(MyUser currentUser, String url) async {
    try {
      //query to write into profile table
      await supabase
          .from('user_profile')
          .update({'profile_picture': url}).eq('uid', currentUser.uId);
      //returning picture url stored into the storage
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> updateCurrentImage(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = file.name;
      await supabase.storage
          .from('profilepictures')
          .uploadBinary(fileName, bytes);
      final imageUrl =
          supabase.storage.from('profilepictures').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<XFile?> getImageFromGalery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      throw Exception(e);
    }
  }
}
