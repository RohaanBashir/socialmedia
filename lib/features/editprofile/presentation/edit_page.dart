import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/commonWidgets/textfield.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/editprofile/cubit/editprofile_cubit.dart';
import 'package:social/features/profile/cubit/profile_cubit.dart';
import 'package:social/features/profile/presentation/profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState();

  final TextEditingController description = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<EditprofileCubit>(context).currentImage =
        BlocProvider.of<ProfileCubit>(context).currentProfile!.profilePicture;

    BlocProvider.of<EditprofileCubit>(context).tempImage =
        BlocProvider.of<ProfileCubit>(context).currentProfile!.profilePicture;

    BlocProvider.of<EditprofileCubit>(context).currDescription =
        BlocProvider.of<ProfileCubit>(context).currentProfile!.description;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editProfileCubit = BlocProvider.of<EditprofileCubit>(context);
    final profileCubit = BlocProvider.of<ProfileCubit>(context);
    description.text = profileCubit.currentProfile!.description;
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      drawerScrimColor: Colors.white10,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                editProfileCubit.upLoad(
                    authCubit.currentUser!,
                    profileCubit.currentProfile!.profilePicture,
                    description.text);
              },
              child: Icon(Icons.check),
            ),
          )
        ],
        backgroundColor: Colors.white10,
        title: Text("Update Profile"),
        centerTitle: true,
      ),
      body: BlocConsumer<EditprofileCubit, EditprofileState>(
        listener: (context, state) {
          if (state is EditError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error.toString())));
          }
          if (state is EditUpdateImgageSuccess) {}

          if (state is EditDescriptionSuccess) {}

          if (state is EditUploadSuccess) {
            profileCubit.currentProfile!.description = state.description;
            profileCubit.currentProfile!.profilePicture = state.url;
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
        builder: (context, state) {
          if (state is EditLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 30),
                  Text(state.status)
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: editProfileCubit.tempImage!,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.secondaryColor),
                                child: IconButton(
                                  iconSize: 50,
                                  icon: Icon(Icons.edit,
                                      color: AppColors.primaryLightColor),
                                  onPressed: () {
                                    editProfileCubit.updateCurrentImage();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
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
            );
          }
        },
      ),
    );
  }
}
