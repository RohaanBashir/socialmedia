part of 'comment_cubit.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}
final class CommentISuccess extends CommentState {}
final class CommentLoading extends CommentState {}
final class CommentError extends CommentState {
  CommentError({required this.error});
  final String error;
}

final class CommentFetchSuccess extends CommentState {

  CommentFetchSuccess({required this.comments});
  final List<String> comments;
}


