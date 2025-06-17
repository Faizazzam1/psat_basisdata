import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psat_basis_data/auth/auth_service.dart';
import 'package:psat_basis_data/pages/register_page.dart';
import 'package:psat_basis_data/pages/toko_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //get auth service
  final authService = AuthSupabaseService();

  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //ketika button login diklik
  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      await authService.signInWithPassword(email, password);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const TokoPage()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Username dan Password salah")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //email input
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Masukan Email"),
          ),

          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Masukan Password"),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ElevatedButton(
                onPressed: login, child: const Text("Login Sekarang")),
          ),

          SizedBox(
            height: 10,
          ),

          GestureDetector(
            child: Center(child: Text("Belum punya akun? Register sekarang")),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegisterPage();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
