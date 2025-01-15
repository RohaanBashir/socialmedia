// ignore_for_file: must_be_immutable

part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class Loading extends AuthState {}

final class Error extends AuthState {
  Error(this.error);
  String error;
}

final class Success extends AuthState {}
