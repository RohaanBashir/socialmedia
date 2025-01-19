part of 'editprofile_cubit.dart';

@immutable
sealed class EditprofileState {}

final class EditprofileInitial extends EditprofileState {}

final class EditSuccess extends EditprofileState {}

final class EditError extends EditprofileState {
  final String error;

  EditError({required this.error});
}

final class EditLoading extends EditprofileState {
  EditLoading({required this.status});
  final String status;
}

final class EditUploadingToStorage extends EditprofileState {}

final class EditUpdateImgageSuccess extends EditprofileState {
  EditUpdateImgageSuccess({required this.url});
  final String url;
}

final class EditUploadSuccess extends EditprofileState {
  EditUploadSuccess({required this.url, required this.description});
  final String url;
  final String description;
}

class EditDescriptionSuccess extends EditprofileState {
  EditDescriptionSuccess({required this.description});
  final String description;
}
