// ignore_for_file: file_names

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepo {
  Future<UserResponse> isAuthenticated();
  Future<UserResponse> getCurrentUser();
  Future<AuthResponse> loginWithEmailAndPass(String email, String pass);
  Future<void> signOut();
  Future<AuthResponse> registerWithEmailAndPass(String email, String pass);
}
