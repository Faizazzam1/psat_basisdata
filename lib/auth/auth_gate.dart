import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psat_basis_data/pages/login_page.dart';
import 'package:psat_basis_data/pages/toko_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        //if valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return TokoPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
