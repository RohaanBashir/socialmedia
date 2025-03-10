import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/features/postTIle/presentation/post_tile.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/presentation/login.dart';
import 'package:social/features/createpost/presentation/create_post.dart';
import 'package:social/features/home/cubit/home_cubit.dart';
import 'package:social/features/profile/presentation/profile.dart';
import '../../../entities/user-profile.dart';
import '../../profile/cubit/profile_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController _searchController = SearchController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    await homeCubit.fetchUsers();
    await homeCubit.fetchUserSubscribedIds(authCubit.currentUser!.uId);
    await homeCubit.fetchPosts(homeCubit.subscribedUserIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final profile = BlocProvider.of<ProfileCubit>(context);

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is SignoutSucess) {
          BlocProvider.of<AuthCubit>(context).currentUser = null;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
        if (state is HomeError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.toString())));
        }
      },
      builder: (context, state) {
        if (state is HomeLoading) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return Scaffold(
              appBar: AppBar(
                  foregroundColor: AppColors.secondaryColor,
                  backgroundColor: Colors.white10,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Center(child: Text("Home"))),
                      _buildSearchAnchor(homeCubit)
                    ],
                  )),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 30),
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                    shape: CircleBorder(),
                    backgroundColor: AppColors.secondaryColor,
                    enableFeedback: true,
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePost()));
                      _initializeData();
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ),
              drawer: Drawer(
                backgroundColor: Colors.white,
                child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Center(
                        child: Text(
                          'O P T I O N S',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.home_outlined),
                            title: Text('H O M E'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: 10),
                          ListTile(

                            leading: Icon(Icons.person_outline),
                            title: Text('P R O F I L E'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                            profile: profile.currentProfile!,
                                          )));
                            },
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.settings_outlined),
                            title: Text('S E T T I N G S'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      endIndent: 20,
                      indent: 20,
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text('L O G O U T'),
                      onTap: () {
                        homeCubit.signOut();
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              body: state is HomeFetchUserPostsSuccess
                  ? ListView.builder(
                      itemCount: state.post.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostTile(post: state.post[index]);
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    ));
        }
      },
    );
  }

  Widget _buildSearchAnchor(HomeCubit homeCubit) {
    return SearchAnchor(
      searchController: _searchController,
      viewHintText: 'Search users...',
      viewLeading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _searchController.closeView(''),
      ),
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.toLowerCase();
        final filteredUsers = homeCubit.users.where((user) {
          return user.name.toLowerCase().contains(query);
        }).toList();

        return [
          if (filteredUsers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No users found'),
              ),
            )
          else
            ...filteredUsers.map((user) => ListTile(
                  title: Text(user.name),
                  leading: CircleAvatar(
                    child: Text(user.name[0]),
                  ),
                  onTap: () async {
                    controller.closeView(user.name);
                    var userProfile = await homeCubit.returnUserProfile(user);
                    await _navigateToProfile(context, userProfile);
                    homeCubit.fetchPosts(homeCubit.subscribedUserIds);
                  },
                )),
        ];
      },
    );
  }

  Future<void> _navigateToProfile(
      BuildContext context, UserProfile user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          profile: user,
        ),
      ),
    );
  }
}
