import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/commonWidgets/textfield.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/createpost/cubit/createpost_cubit.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController description = TextEditingController();
  CroppedFile? image;
  String? imgUrl;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final postCreateCubit = BlocProvider.of<CreatepostCubit>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () async {
                if (image != null) {
                  imgUrl = await postCreateCubit.saveImgToStore(image!);
                  if (imgUrl != null) {
                    postCreateCubit.createPost(
                        description.text, imgUrl!, authCubit.currentUser!);
                  }
                }
              },
              child: Icon(Icons.upload_file),
            ),
          )
        ],
        foregroundColor: AppColors.secondaryColor,
        backgroundColor: Colors.white10,
        title: Text(
          "Create Post",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15, bottom: 30),
        child: SizedBox(
          height: 70,
          width: 150,
          child: FloatingActionButton(
            backgroundColor: AppColors.secondaryColor,
            enableFeedback: true,
            onPressed: () {
              postCreateCubit.selectImgFromDevice();
              // if (tempImage != null) {
              //image = await postCreateCubit.cropImage(tempImage);
            },
            child: Text(
              "Add Image",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      ),
      body: BlocConsumer<CreatepostCubit, CreatepostState>(
          bloc: postCreateCubit,
          listener: (context, state) {
            if (state is CreatePostError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
            if (state is CreatePostImageSelected) {
              image = state.imgFile;
            }
            if (state is CreatePostImgSavedToStore) {
              imgUrl = state.imgUrl;
            }

            if (state is CreatePostImgSavedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Post Uploaded Successfully!")));
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is CreatePostLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(state.status),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      state is CreatePostImageSelected
                          ? Center(
                              child: AspectRatio(
                                aspectRatio: 4 / 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    image: DecorationImage(
                                        image:
                                            FileImage(File(state.imgFile.path)),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            )
                          : Text("No image selected yet"),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        callback: () {},
                        controller: description,
                        hint: "Description",
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
