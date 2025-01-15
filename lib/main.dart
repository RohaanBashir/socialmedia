// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/presentation/login.dart';
import 'package:social/features/auth/presentation/register.dart';
import 'package:social/features/home/cubit/home_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kggaaykornvmlmcomopz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnZ2FheWtvcm52bWxtY29tb3B6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY3Nzg4ODksImV4cCI6MjA1MjM1NDg4OX0.85HU08WGbnGgFwhwqJ0wUjo9kqESLlrf_JZ9e2Q12i8',
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
        // Add more BlocProvider instances here
      ],
      child: MaterialApp(
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
