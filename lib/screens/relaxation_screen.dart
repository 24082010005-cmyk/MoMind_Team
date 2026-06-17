import 'package:flutter/material.dart';
import '../app_colors.dart';


class RelaxationScreen extends StatefulWidget {
  const RelaxationScreen({super.key});


  @override
  State<RelaxationScreen> createState() => _RelaxationScreenState();
}


class _RelaxationScreenState extends State<RelaxationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heartScale;


  String _instruction = "Bersiap...";
  String _subInstruction = "Duduklah dengan nyaman";
  bool _isBreathing = false;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Durasi tarik/hembus napas
    );


    _heartScale = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));


    // Mulai siklus pernapasan setelah sedikit jeda
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _startBreathingCycle();
    });
  }


  Future<void> _startBreathingCycle() async {
    _isBreathing = true;
    while (_isBreathing && mounted) {
      // Fase 1: Tarik Napas (4 detik)
      setState(() {
        _instruction = "Tarik Napas...";
        _subInstruction = "Rasakan udara segar masuk";
      });
      await _controller.forward(); // Animasi membesar


      if (!mounted) break;


      // Fase 2: Tahan Napas (4 detik)
      setState(() {
        _instruction = "Tahan...";
        _subInstruction = "Biarkan ketenangan menetap";
      });
      await Future.delayed(const Duration(seconds: 4));


      if (!mounted) break;


      // Fase 3: Hembuskan Napas (4 detik)
      setState(() {
        _instruction = "Hembuskan perlahan...";
        _subInstruction = "Lepaskan semua bebanmu";
      });
      await _controller.reverse(); // Animasi mengecil


      if (!mounted) break;


      // Fase 4: Jeda sebelum mengulang (2 detik)
      setState(() {
        _instruction = "Istirahat sejenak...";
        _subInstruction = "Persiapkan napas berikutnya";
      });
      await Future.delayed(const Duration(seconds: 2));
    }
  }


  @override
  void dispose() {
    _isBreathing = false;
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.pinkDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.pinkDark,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _subInstruction,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 80),


            // Animasi Hati
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartScale.value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.gradientStart.withOpacity(0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pinkAccent.withOpacity(0.2),
                          blurRadius: 30 * _heartScale.value,
                          spreadRadius: 10 * _heartScale.value,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.pinkAccent,
                      size: 60,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}



