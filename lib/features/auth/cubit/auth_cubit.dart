// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/entities/user.dart';
import 'package:social/features/auth/data/supabase-auth-repo.dart';
import 'package:social/features/auth/repository/authRepo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  MyUser? currentUser;
  AuthRepo repo = SupabaseAuthRepo();

  void login(String email, String pass) async {
    try {
      emit(Loading());
      await repo.loginWithEmailAndPass(email, pass);
      emit(Success());
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void register(String name, String pass, String email) async {
    try {
      emit(Loading());
      AuthResponse res = await repo.registerWithEmailAndPass(email, pass);
      currentUser = MyUser(name, email, res.user!.id);
      emit(Success());
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void signOut() async {
    try {
      emit(Loading());
      await repo.signOut();
      emit(Success());
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  MyUser? getCurrentUser() {
    return currentUser;
  }
}
