import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart'; // 🛠️ Import AppColors untuk warna gradasi & snackbar
import '../main_screen.dart';
import 'register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();


  bool loading = false;


  Future<void> login() async {
    if (emailC.text.trim().isEmpty || passC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password wajib diisi")),
      );
      return;
    }


    setState(() => loading = true);


    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );


      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil"),
          backgroundColor: AppColors.success, // 🛠️ Menggunakan AppColors
        ),
      );


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;


      switch (e.code) {
        case 'user-not-found':
          message = "Email tidak terdaftar";
          break;
        case 'wrong-password':
          message = "Password salah";
          break;
        case 'invalid-email':
          message = "Format email tidak valid";
          break;
        case 'invalid-credential':
          message = "Email atau password salah";
          break;
        default:
          message = e.message ?? "Login gagal";
      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error, // 🛠️ Menggunakan AppColors
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: AppColors.error, // 🛠️ Menggunakan AppColors
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }


  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // 🛠️ Mengambil config text style dari theme global agar konsisten
    final textTheme = Theme.of(context).textTheme;


    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart, // 🛠️ Terpusat di app_colors.dart
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ilustrasi Ikon Kecil di atas judul
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.pinkAccent, // 🛠️ Menggunakan AppColors
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),


                // Judul Welcome
                Text(
                  "Selamat Datang",
                  style: textTheme
                      .headlineMedium, // 🛠️ Menggunakan gaya dari Theme Global
                ),
                const SizedBox(height: 4),
                Text(
                  "Silakan masuk ke akun MoMind Anda",
                  style: textTheme
                      .bodySmall, // 🛠️ Menggunakan gaya dari Theme Global
                ),
                const SizedBox(height: 36),


                // Form Input Email
                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    // 🛠️ Jauh lebih bersih karena dekorasi border dll sudah diatur di app_theme.dart
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "Alamat Email",
                  ),
                ),
                const SizedBox(height: 16),


                // Form Input Password
                TextField(
                  controller: passC,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: const InputDecoration(
                    // 🛠️ Otomatis estetik mengikuti global theme
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintText: "Kata Sandi",
                  ),
                ),
                const SizedBox(height: 28),


                // Tombol Login Estetik
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: loading ? null : login,
                    // 🛠️ Style rapi karena struktur utamanya sudah didefinisikan di app_theme.dart
                    child: loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text("Masuk"),
                  ),
                ),
                const SizedBox(height: 20),


                // Tombol Pindah ke Halaman Daftar
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, fontFamily: 'sans-serif'),
                      children: [
                        TextSpan(
                          text: "Belum memiliki akun? ",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: "Daftar",
                          style: TextStyle(
                            color: AppColors.pinkDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
