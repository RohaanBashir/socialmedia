import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:social/entities/user.dart';

abstract class EditProfileRepo {
  Future<void> uploadImage(MyUser currentUser, String url);
  Future<void> updateDescription(MyUser currentUser, String description);
  Future<String> updateCurrentImage(XFile file);
  Future<XFile?> getImageFromGalery();
}
