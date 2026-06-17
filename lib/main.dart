import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app_theme.dart'; // 🛠️ TAMBAHAN: Import file tema pastel pink MoMind
import 'splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // 🚀 Inisialisasi langsung ke Firebase Cloud resmi (Production Server) dipertahankan utuh
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(const MomindApp());
}


class MomindApp extends StatelessWidget {
  const MomindApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Momind',


      // 🛠️ PERBAIKAN: Mengganti ThemeData lama dengan tema estetik MoMind yang sudah kita buat
      theme: AppTheme.lightTheme,


      home: const SplashScreen(),
    );
  }
}



