// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/presentation/login.dart';
import 'package:social/features/auth/repository/authRepo.dart';
import 'package:social/features/home/cubit/home_cubit.dart';
import 'package:social/features/profile/presentation/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);

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
              backgroundColor: Colors.white10,
              centerTitle: true,
              title: Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Center(),
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
                                    builder: (context) => ProfilePage()));
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
          );
        }
      },
    );
  }
}
