import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/features/comments/data/supabase_comments_repo.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  final commentRepo = SupabaseCommentsRepo();
  final comments = <String>[];

  Future<void> sendComment(String postid, String comment)async{
    try{
      emit(CommentLoading());
      await commentRepo.sendComment(comment,postid);
      comments.add(comment);
      emit(CommentFetchSuccess(comments: comments));
    }catch(e){
      emit(CommentError(error: e.toString()));
    }
  }

  Future<void> fetchComments(String postId)async{

    try{
      emit(CommentLoading());
      final List<Map<String, dynamic>> temp = await commentRepo.fetchComments(postId);
      final comment = temp[0]['comments'] as List<dynamic>;

      for(var commentss in comment){
        var t = commentss.toString();
        comments.add(t);
      }
      emit(CommentFetchSuccess(comments: comments));
    }catch(e){
      emit(CommentError(error: e.toString()));
    }
  }
}
