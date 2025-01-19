import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/commonWidgets/myButton.dart';
import 'package:social/commonWidgets/textfield.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/auth/presentation/register.dart';
import 'package:social/features/home/presentation/home_page.dart';
import 'package:social/features/profile/cubit/profile_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final profileCubit = BlocProvider.of<ProfileCubit>(context);

    return Scaffold(
        appBar: AppBar(
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            title: const Text("Login"),
            centerTitle: true,
            backgroundColor: AppColors.primaryLightColor),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.toString())));
            }

            if (state is Success) {
              profileCubit.fetchProfileData(authCubit.currentUser!);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login here to stay connected with friends!",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    MyTextField(
                        keyboardType: TextInputType.emailAddress,
                        callback: () {},
                        controller: emailController,
                        hint: "Email"),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      callback: () {},
                      controller: passController,
                      hint: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      obsqureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: AppColors.primaryLightColor,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyButton(
                        title: "Login",
                        onPressed: () {
                          authCubit.login(
                              emailController.text, passController.text);
                        })
                  ],
                ),
              );
            }
          },
        ));
  }
}
