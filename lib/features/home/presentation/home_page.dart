// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/presentation/login.dart';
import 'package:social/features/auth/repository/authRepo.dart';
import 'package:social/features/home/cubit/home_cubit.dart';

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
              title: Text("Home Page"),
              actions: [
                IconButton(
                    onPressed: () {
                      homeCubit.signOut();
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: Center(),
          );
        }
      },
    );
  }
}
