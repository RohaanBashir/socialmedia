import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appColors/lightmode.dart';
import '../../../entities/post.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/post_tile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {



  @override
  Widget build(BuildContext context) {
    final profileTileCubit = BlocProvider.of<PostTileCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit> (context);

    return BlocConsumer<PostTileCubit, PostTileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 3.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User's Profile and Name
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            widget.post.img!), // Use user's profile picture
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.post.postUser!.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Post Image
                CachedNetworkImage(
                  imageUrl: widget.post.img!,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),

                // Caption, Likes, and Comments
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.postDescription!,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          GestureDetector(
                            child: widget.post.likes.contains(authCubit.currentUser!.uId)
                                ? const Icon(Icons.favorite,
                                    size: 30.0, color: AppColors.secondaryColor)
                                : const Icon(Icons.favorite_border,
                                    size: 30.0,
                                    color: AppColors.secondaryColor),
                            onTap: () {
                              profileTileCubit.addLikeOrUnLike(widget.post, authCubit.currentUser!.uId);
                            },
                          ),
                          const SizedBox(width: 4.0),
                          GestureDetector(
                            child: Text(
                              "${widget.post.likes.length -2 } likes",
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                          const SizedBox(width: 16.0),
                          const Icon(Icons.comment,
                              size: 30.0, color: Colors.green),
                          const SizedBox(width: 4.0),
                          Text(
                            "${widget.post.comments.length - 2 } comments",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
