part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileError extends ProfileState {
  ProfileError({required this.error});
  final String error;
}

final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileFetch extends ProfileState {}

final class ProfileFetchSuccess extends ProfileState {}

final class ProfileSubButtonPressedLoading extends ProfileState{}

final class SubButtonSuccss extends ProfileState{}


