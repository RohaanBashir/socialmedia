// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/features/auth/data/supabase-auth-repo.dart';
import 'package:social/features/auth/repository/authRepo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  AuthRepo authrepo = SupabaseAuthRepo();

  void signOut() async {
    try {
      emit(HomeLoading());
      await authrepo.signOut();
      emit(SignoutSucess());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
