import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/constants.dart';
import 'features/dropflow/dropflow_startup_gate.dart'; // 🔄 Use startup gate before dashboard

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl, // ✅ Your live Supabase project URL
    anonKey: supabaseAnonKey, // ✅ Anon key securely stored in constants.dart
  );

  runApp(const SplitmindApp());
}

class SplitmindApp extends StatelessWidget {
  const SplitmindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitmind Dropshipping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Supabase dark base
        primaryColor: Colors.white,
        splashColor: Colors.white12,
        highlightColor: Colors.white10,
        hoverColor: Colors.white12,
        focusColor: Colors.white10,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white70),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF0F172A)),

        iconTheme: const IconThemeData(color: Colors.white70),

        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),

        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          surface: Color(0xFF121212),
          onSurface: Colors.white,
        ),
      ),
      home: const DropFlowStartupGate(), // 🔥 Launch into onboarding flow first
    );
  }
}
