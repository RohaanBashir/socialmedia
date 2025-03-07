import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/editprofile/presentation/edit_page.dart';
import 'package:social/features/home/cubit/home_cubit.dart';
import 'package:social/features/profile/cubit/profile_cubit.dart';

import '../../../entities/user-profile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.profile});

  UserProfile profile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    setSubscribedOrNotSubed();
    super.initState();
  }

  void setSubscribedOrNotSubed(){
    final profileCubit = BlocProvider.of<ProfileCubit>(context);
    final home = BlocProvider.of<HomeCubit>(context);
    final authRepo = BlocProvider.of<AuthCubit>(context);
    // int count = home.subscribedUserIds.where((id) => id == authRepo.currentUser!.uId).length;
    if (home.subscribedUserIds.contains(widget.profile.uId)){
      profileCubit.issubscribed = true;
    } else {
      profileCubit.issubscribed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final profileCubit = BlocProvider.of<ProfileCubit>(context);

    //if the user is the current user
    if (widget.profile.uId == authCubit.currentUser!.uId) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white10,
            title: Text(authCubit.currentUser!.name),
            actions: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()));
                    },
                    child: Icon(Icons.edit),
                  ))
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  profileCubit.currentProfile!.profilePicture,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Followers: ${profileCubit.currentProfile!.followers}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text("Following: ${profileCubit.currentProfile!.follwing}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        profileCubit.currentProfile!.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              //post section goes from here
            ],
          ));
    }

    //if the user is accessing some other user current user
    else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white10,
            title: Text(widget.profile.name),
          ),
          body: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.profile.profilePicture,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Subscribers: ${widget.profile.followers}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextButton(
                          onPressed: () {
                            profileCubit.subscribeUnsubscribeToUser(widget.profile.uId,context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: profileCubit.issubscribed
                                ? Colors.red
                                : AppColors.secondaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: state is ProfileSubButtonPressedLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  profileCubit.issubscribed
                                      ? "Unsubscribe"
                                      : "Subscribe",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            widget.profile.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  //post section goes from here
                ],
              );
            },
          ));
    }
  }
}