import 'dart:convert'; // ✨ TAMBAHAN: Untuk mengubah gambar jadi teks (Base64)
import 'dart:typed_data'; // ✨ TAMBAHAN: Untuk mengelola bytes gambar yang aman di Web
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // ✨ TAMBAHAN: Package picker gambar
import '../login_screen.dart';
import '../app_colors.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String role = '';
  String photoUrl = ''; // Akan menyimpan teks Base64 atau URL lama


  int totalMood = 0;
  int totalDiary = 0;


  bool isLoading = true;
  bool isUploadingPhoto = false;


  @override
  void initState() {
    super.initState();
    loadProfile();
  }


  Future<void> loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;


      if (user == null) return;


      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();


      final moodSnapshot = await FirebaseFirestore.instance
          .collection('moods')
          .where('userId', isEqualTo: user.uid)
          .get();


      final diarySnapshot = await FirebaseFirestore.instance
          .collection('diaries')
          .where('userId', isEqualTo: user.uid)
          .get();


      if (mounted) {
        setState(() {
          name = userDoc.data()?['name'] ?? '-';
          email = userDoc.data()?['email'] ?? '-';
          role = userDoc.data()?['role'] ?? 'user';
          photoUrl = userDoc.data()?['photoUrl'] ?? '';


          totalMood = moodSnapshot.docs.length;
          totalDiary = diarySnapshot.docs.length;


          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Profile Error: $e");


      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  // ✨ FITUR BARU: Mengubah gambar menjadi teks Base64 lalu disimpan ke Firestore
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();


    // 1. Pilih gambar dari galeri ponsel
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality:
          50, // Diturunkan agar teks Base64 ringan dan tidak memberatkan Firestore
      maxWidth: 300, // Dibatasi agar pas untuk ukuran avatar saja
    );


    if (image == null) return; // Pengguna membatalkan pemilihan gambar


    setState(() {
      isUploadingPhoto = true;
    });


    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;


      // 2. Baca gambar sebagai Bytes (Uint8List), ini aman untuk Web maupun Mobile
      final Uint8List imageBytes = await image.readAsBytes();


      // 3. Ubah Bytes gambar menjadi teks (String Base64)
      final String base64Image = base64Encode(imageBytes);


      // 4. Update data URL foto di Firestore dokumen user langsung menggunakan teks gambar tersebut
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoUrl': base64Image,
      });


      if (mounted) {
        setState(() {
          photoUrl = base64Image; // Terapkan foto baru ke tampilan
          isUploadingPhoto = false;
        });


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Yey! Foto profil barumu berhasil dipasang ✨"),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      debugPrint("Upload Photo Error: $e");
      if (mounted) {
        setState(() {
          isUploadingPhoto = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oops! Gagal memperbarui foto profil 😢"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }


  Future<void> editName() async {
    final controller = TextEditingController(text: name);


    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Ganti Nama Panggilan ✏️",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.pinkDark,
              fontSize: 18,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.textMain),
            decoration: InputDecoration(
              hintText: "Masukkan nama barumu...",
              filled: true,
              fillColor: AppColors.scaffoldBackground.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.pinkAccent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.pinkPrimary.withOpacity(0.3),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pinkAccent,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );


    if (result == null || result.isEmpty) return;


    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;


      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': result,
      });


      setState(() {
        name = result;
      });


      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Yey! Nama panggilanmu berhasil diperbarui ✨"),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      debugPrint("Update Name Error: $e");
    }
  }


  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();


    if (!mounted) return;


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }


  Widget buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.pinkPrimary.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: AppColors.pinkPrimary.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.gradientStart,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.pinkDark, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Profil Pengguna",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.gradientStart,
        foregroundColor: AppColors.pinkDark,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.pinkAccent),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),


                  // 🛠️ ORNAMEN: Bingkai Foto Profil Pastel Melengkung Dinamis
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gradientStart,
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: AppColors.gradientStart,
                            // ✨ DIUBAH: Pengecekan cerdas antara Web URL lama atau teks Base64 baru
                            backgroundImage: photoUrl.isNotEmpty
                                ? (photoUrl.startsWith('http')
                                      ? NetworkImage(photoUrl) as ImageProvider
                                      : MemoryImage(base64Decode(photoUrl)))
                                : null,
                            child: photoUrl.isEmpty && !isUploadingPhoto
                                ? const Icon(
                                    Icons.face_rounded,
                                    size: 54,
                                    color: AppColors.pinkDark,
                                  )
                                : isUploadingPhoto
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.pinkAccent,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        // ✨ Tombol Kamera Interaktif untuk Mengganti Foto Profil
                        GestureDetector(
                          onTap: isUploadingPhoto ? null : pickAndUploadImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.pinkAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),


                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),


                  const SizedBox(height: 24),


                  // KARTU INDIKATOR ROLE AKUN
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.pinkPrimary.withOpacity(0.12),
                      ),
                    ),
                    child: ListTile(
                      horizontalTitleGap: 12,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shield_moon_rounded,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ),
                      title: const Text(
                        "Tipe Akun",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        role.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 16),


                  // SEKTOR KARTU HISTORI TOTAL AKTIVITAS (MOOD & DIARY)
                  Row(
                    children: [
                      buildStatCard(
                        "Catatan Mood",
                        totalMood.toString(),
                        Icons.sentiment_satisfied_alt_rounded,
                      ),
                      const SizedBox(width: 14),
                      buildStatCard(
                        "Lembar Diary",
                        totalDiary.toString(),
                        Icons.auto_stories_rounded,
                      ),
                    ],
                  ),


                  const SizedBox(height: 32),


                  // 🛠️ TOMBOL EDIT NAMA UTAMA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: editName,
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text(
                        "Ubah Nama Panggilan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.pinkAccent,
                        side: const BorderSide(
                          color: AppColors.pinkAccent,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 12),


                  // 🛠️ TOMBOL LOGOUT SEGAR MERAH LEMBUT
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(
                        Icons.power_settings_new_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        "Keluar dari Aplikasi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}



