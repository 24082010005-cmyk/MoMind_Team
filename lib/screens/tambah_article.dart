import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


import '../app_colors.dart';


class TambahArticleScreen extends StatefulWidget {
  const TambahArticleScreen({super.key});


  @override
  State<TambahArticleScreen> createState() => _TambahArticleScreenState();
}


class _TambahArticleScreenState extends State<TambahArticleScreen> {
  final titleC = TextEditingController();
  final categoryC = TextEditingController();
  final authorC = TextEditingController();
  final contentC = TextEditingController();


  final ImagePicker _picker = ImagePicker();


  Uint8List? selectedImageBytes;
  String? imageBase64;


  bool isLoading = false;


  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );


      if (image == null) return;


      final bytes = await image.readAsBytes();


      setState(() {
        selectedImageBytes = bytes;
        imageBase64 = base64Encode(bytes);
      });
    } catch (e) {
      debugPrint("Pick Image Error: $e");
    }
  }


  Future<void> saveArticle() async {
    if (titleC.text.trim().isEmpty ||
        categoryC.text.trim().isEmpty ||
        authorC.text.trim().isEmpty ||
        contentC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }


    try {
      setState(() {
        isLoading = true;
      });


      await FirebaseFirestore.instance.collection('articles').add({
        'title': titleC.text.trim(),
        'category': categoryC.text.trim(),
        'author': authorC.text.trim(),
        'content': contentC.text.trim(),
        'imageBase64': imageBase64 ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });


      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Artikel berhasil ditambahkan ✨"),
          backgroundColor: AppColors.success,
        ),
      );


      Navigator.pop(context);
    } catch (e) {
      debugPrint("Save Article Error: $e");


      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan artikel"),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textMain),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }


  Widget buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: selectedImageBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(selectedImageBytes!, fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 56,
                    color: AppColors.pinkAccent,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Pilih Gambar dari Galeri",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
      ),
    );
  }


  @override
  void dispose() {
    titleC.dispose();
    categoryC.dispose();
    authorC.dispose();
    contentC.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Tulis Artikel Baru",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.pinkDark,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            buildImagePicker(),


            buildTextField(
              controller: titleC,
              label: "Judul Artikel",
              prefixIcon: Icons.title_rounded,
            ),


            buildTextField(
              controller: categoryC,
              label: "Kategori (contoh: Kecemasan, Meditasi)",
              prefixIcon: Icons.category_rounded,
            ),


            buildTextField(
              controller: authorC,
              label: "Nama Penulis",
              prefixIcon: Icons.rate_review_rounded,
            ),


            buildTextField(
              controller: contentC,
              label: "Tulis isi artikel kesehatan mental di sini...",
              prefixIcon: Icons.description_rounded,
              maxLines: 6,
            ),


            const SizedBox(height: 24),


            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : saveArticle,
                icon: isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.cloud_upload_rounded),
                label: Text(
                  isLoading ? "Sedang Menyimpan..." : "Publikasikan Artikel",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkAccent,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



