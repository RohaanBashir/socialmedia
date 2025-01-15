import 'package:social/features/auth/repository/authRepo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepo extends AuthRepo {
  final supabase = Supabase.instance.client;
  @override
  Future<UserResponse> getCurrentUser() async {
    try {
      UserResponse res = await supabase.auth.getUser();
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AuthResponse> loginWithEmailAndPass(String email, String pass) async {
    try {
      AuthResponse res =
          await supabase.auth.signInWithPassword(email: email, password: pass);
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AuthResponse> registerWithEmailAndPass(
      String email, String pass) async {
    try {
      AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: pass,
      );
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserResponse> isAuthenticated() async {
    try {
      UserResponse res = await supabase.auth.getUser();
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }
}
