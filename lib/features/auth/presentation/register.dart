import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/appColors/lightmode.dart';
import 'package:social/commonWidgets/myButton.dart';
import 'package:social/commonWidgets/textfield.dart';
import 'package:social/features/auth/cubit/auth_cubit.dart';
import 'package:social/features/home/presentation/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
        appBar: AppBar(
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            title: const Text("Register"),
            centerTitle: true,
            backgroundColor: AppColors.primaryLightColor),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Success) {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
            if (state is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.toString())));
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset("assets/login.svg"),
                        SizedBox(
                          height: 50,
                        ),
                        MyTextField(
                            keyboardType: TextInputType.name,
                            callback: () {},
                            controller: nameController,
                            hint: "Name"),
                        SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                          callback: () {},
                          controller: emailController,
                          hint: "Email",
                          keyboardType: TextInputType.emailAddress,
                          obsqureText: false,
                        ),
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
                          height: 20,
                        ),
                        MyTextField(
                          callback: () {},
                          controller: conPassController,
                          hint: "Confirm Password",
                          keyboardType: TextInputType.visiblePassword,
                          obsqureText: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MyButton(
                            title: "Register",
                            onPressed: () {
                              if (passController.text ==
                                  conPassController.text) {
                                authCubit.register(nameController.text,
                                    emailController.text, emailController.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Confirm password and password not matching")));
                                passController.text = "";
                                conPassController.text = "";
                              }
                            })
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
