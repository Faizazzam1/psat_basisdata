import 'package:flutter/material.dart';
import 'package:psat_basis_data/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: "https://bhrroinlawcrdpclxyml.supabase.co", 
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJocnJvaW5sYXdjcmRwY2x4eW1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NTIwMDMsImV4cCI6MjA2MTAyODAwM30.8E_QtcGeoJrH_Pnq7edrnch-9KK4Vgf_-Z0fqmGRe6M");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
