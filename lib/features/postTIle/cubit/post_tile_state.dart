part of 'post_tile_cubit.dart';

@immutable
sealed class PostTileState {}

final class PostTileInitial extends PostTileState {}

final class PostLikeOrUnLikeSuccess extends PostTileState {}

final class PostLikeOrUnLikeLoading extends PostTileState {}
final class PostError extends PostTileState {

  PostError({required this.error});
  final String error;
}
