import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // signin
  Future<AuthResponse> signInWithPassword(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }
  //signup
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await supabase.auth.signUp(
      email: email,
      password: password
    );
  }

  //logout
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  //get email user
  String? getUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;

    return user?.email;
  }
}