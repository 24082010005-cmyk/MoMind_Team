import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../app_colors.dart'; // 🛠️ TAMBAHAN: Import AppColors terpusat
import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  // 🛠️ GlobalKey untuk validasi form sesuai kriteria UAS (Tetap dipertahankan)
  final _formKey = GlobalKey<FormState>();


  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();


  bool loading = false;


  Future<void> register() async {
    // 🛠️ Validasi form sebelum mengeksekusi
    if (!_formKey.currentState!.validate()) return;


    setState(() => loading = true);


    try {
      // 1. CREATE USER FIREBASE AUTH
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailC.text.trim(),
            password: passC.text.trim(),
          );


      // 2. AMBIL UID HASIL DAFTAR
      String uid = userCredential.user!.uid;


      // 3. SIMPAN USER PROFILE KE FIRESTORE (Diberi pengaman terpisah + Timeout)
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
              'name': nameC.text.trim(),
              'email': emailC.text.trim(),
              'role': 'user',
              'createdAt': FieldValue.serverTimestamp(),
            })
            .timeout(
              const Duration(seconds: 4),
            ); // Batasi tunggu maksimal 4 detik


        print("✅ Data Firestore Berhasil Disimpan!");
      } catch (firestoreError) {
        print(
          "⚠️ Firestore terblokir atau timeout, tetapi Auth sukses: $firestoreError",
        );
      }


      if (!mounted) return;


      // 💥 Tampilkan SnackBar Sukses (Kriteria UAS Poin 8)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi Akun Berhasil!"),
          backgroundColor: AppColors.success, // 🛠️ Menggunakan AppColors
        ),
      );


      // 4. DIUBAH: PINDAH KE LOGIN SCREEN
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Register gagal";


      if (e.code == 'email-already-in-use') {
        errorMessage = "Email sudah digunakan oleh akun lain.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password terlalu lemah (minimal 6 karakter).";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Format email salah.";
      } else {
        errorMessage = e.message ?? errorMessage;
      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error, // 🛠️ Menggunakan AppColors
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan sistem: $e"),
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
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // 🛠️ Mengambil skema gaya teks global
    final textTheme = Theme.of(context).textTheme;


    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart, // 🛠️ Sinkron dengan Login Screen
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ilustrasi Ikon Atas
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: AppColors.pinkAccent, // 🛠️ Menggunakan AppColors
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),


                  // Judul Halaman
                  Text(
                    "Buat Akun Baru",
                    style:
                        textTheme.headlineMedium, // 🛠️ Menggunakan Tema Global
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mulai perjalanan kesehatan mentalmu",
                    style: textTheme.bodySmall, // 🛠️ Menggunakan Tema Global
                  ),
                  const SizedBox(height: 36),


                  // NAME FIELD
                  TextFormField(
                    controller: nameC,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: "Nama Lengkap",
                      hintText: "Masukkan nama Anda",
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                  // EMAIL FIELD
                  TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "contoh@email.com",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      if (!value.contains('@')) {
                        return "Format email tidak valid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                  // PASSWORD FIELD
                  TextFormField(
                    controller: passC,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Minimal 6 karakter",
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),


                  // REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: loading ? null : register,
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
                          : const Text("Daftar"),
                    ),
                  ),
                  const SizedBox(height: 20),


                  // LINK KE LOGIN
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'sans-serif',
                        ),
                        children: [
                          TextSpan(
                            text: "Sudah memiliki akun? ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: "Login",
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
      ),
    );
  }
}



