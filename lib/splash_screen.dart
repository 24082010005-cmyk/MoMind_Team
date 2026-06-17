import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math; // Ditambahkan untuk animasi matematika
import 'login_screen.dart';
import 'main_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


// Tambahkan TickerProviderStateMixin untuk mengontrol banyak animasi
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _textController;
  late Animation<double> _heartScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;


  @override
  void initState() {
    super.initState();


    // 1. Setup Animasi Jantung Berdetak (Looping)
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);


    _heartScale = Tween<double>(begin: 0.8, end: 1.15).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOutBack),
    );


    // 2. Setup Animasi Teks Muncul & Menggeser (Satu Kali)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );


    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );


    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutQuart),
          ),
        );


    _textController.forward();


    // Jalankan logika login
    _checkLogin();
  }


  void _checkLogin() async {
    // ⏱️ Diperlama jadi 4 detik agar animasinya puas dilihat!
    await Future.delayed(const Duration(seconds: 4));


    if (!mounted) return;


    FirebaseAuth.instance
        .authStateChanges()
        .first
        .then((user) {
          if (!mounted) return;


          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        })
        .catchError((error) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
  }


  @override
  void dispose() {
    // Jangan lupa bersihkan controller agar tidak memory leak
    _heartController.dispose();
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF0F5), // Lavender Blush
              Color(0xFFFFE4E1), // Misty Rose
              Color(0xFFFFB6C1), // Light Pink pastel
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 💖 Animasi Hati Berdetak
              ScaleTransition(
                scale: _heartScale,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF69B4).withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 90,
                    color: Color(0xFFFF69B4), // Hot Pink yang ceria
                  ),
                ),
              ),
              const SizedBox(height: 35),


              // ✨ Animasi Teks Meluncur dan Muncul
              FadeTransition(
                opacity: _textOpacity,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      const Text(
                        "MoMind",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: Color(0xFFC71585), // Medium Violet Red
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Mental Wellness Companion",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: const Color(0xFFD87093).withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),


              // 🟢 Animasi Loading Titik-titik Lucu (Custom Widget)
              const CuteLoadingDots(),
            ],
          ),
        ),
      ),
    );
  }
}


/// Widget Custom untuk Loading 3 Titik yang Melompat-lompat
class CuteLoadingDots extends StatefulWidget {
  const CuteLoadingDots({super.key});


  @override
  State<CuteLoadingDots> createState() => _CuteLoadingDotsState();
}


class _CuteLoadingDotsState extends State<CuteLoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;


  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }


  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _dotController,
          builder: (context, child) {
            // Menggunakan fungsi sinus (math.sin) untuk membuat efek gelombang/lompat
            double offset = math.sin(
              (_dotController.value * 2 * math.pi) - (index * 1.5),
            );
            return Transform.translate(
              offset: Offset(0, offset * -12), // Lompat ke atas sejauh 12 pixel
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFFD87093).withOpacity(
                    offset > 0 ? 1.0 : 0.5,
                  ), // Warna redup saat di bawah
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD87093).withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}



