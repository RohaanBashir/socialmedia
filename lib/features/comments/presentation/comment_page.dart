import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/commonWidgets/textfield.dart';

import '../../../entities/post.dart';
import '../cubit/comment_cubit.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key, required this.post});

  final Post post;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commentCubit = BlocProvider.of<CommentCubit>(context);
      commentCubit.fetchComments(widget.post.postId!);
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    CommentCubit().close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final commentCubit = BlocProvider.of<CommentCubit>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Comments"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<CommentCubit, CommentState>(
          listener: (context, state) {
            if (state is CommentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // List of comments
                state is CommentFetchSuccess ?
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.comments.length - 1,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(title: Text(state.comments[index+1]));
                      },
                    ),
                  ) : Center(child: CircularProgressIndicator(),),
                if (state is CommentError)
                  Center(
                    child: Text(
                      'Failed to load comments.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                // Input field and Send button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: MyTextField(
                          callback: () {},
                          controller: commentController,
                          hint: "Enter Comment",
                        ),
                      ),
                      IconButton(
                        onPressed: state is CommentLoading
                            ? null
                            : () {
                          commentCubit.sendComment(
                            widget.post.postId!,
                            commentController.text.trim(),
                          );
                          commentController.clear();
                        },
                        icon: state is CommentLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
