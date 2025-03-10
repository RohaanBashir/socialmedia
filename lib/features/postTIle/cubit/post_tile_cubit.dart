import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../entities/post.dart';
import '../data/supabase_post_tile_repo.dart';

part 'post_tile_state.dart';

class PostTileCubit extends Cubit<PostTileState> {
  PostTileCubit() : super(PostTileInitial());

  final profileTileRepo = SupabaseProfileTileRepo();


  void addLikeOrUnLike(Post post, String currentUId) async {
    try{
      if(!post.likes.contains(currentUId)){
        emit(PostLikeOrUnLikeLoading());
        await profileTileRepo.addLikeToPost(post,currentUId);
        post.likes.add(currentUId);
        emit(PostLikeOrUnLikeSuccess());
      }else{
        emit(PostLikeOrUnLikeLoading());
        await profileTileRepo.removeLikeToPost(post,currentUId);
        post.likes.remove(currentUId);
        emit(PostLikeOrUnLikeSuccess());
      }
    }catch(e){
      emit(PostError(error: e.toString()));
    }
  }


}
