// ignore_for_file: must_be_immutable

part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeError extends HomeState {
  HomeError(this.error);
  String error;
}

final class HomeSuccess extends HomeState {}

final class SignoutSucess extends HomeState {}

final class HomeFetchUserPostsSuccess extends HomeState {

  HomeFetchUserPostsSuccess({required this.post});
    List<Post> post;

}
