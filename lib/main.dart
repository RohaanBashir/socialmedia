// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/presentation/login.dart';
import 'package:social/features/auth/presentation/register.dart';
import 'package:social/features/editprofile/cubit/editprofile_cubit.dart';
import 'package:social/features/home/cubit/home_cubit.dart';
import 'package:social/features/home/presentation/home_page.dart';
import 'package:social/features/profile/cubit/profile_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fxdetvhzodhrgkrqiuxq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ4ZGV0dmh6b2RocmdrcnFpdXhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcxMDY1NTcsImV4cCI6MjA1MjY4MjU1N30.neqPqf4wIO1nPco85T_9Qy3foGE46tgsLiVsnPHitv4',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),

        BlocProvider<EditprofileCubit>(
          create: (context) => EditprofileCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
        ),
        // Add more BlocProvider instances here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(250, 255, 255, 255),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
