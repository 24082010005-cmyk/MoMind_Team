import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_colors.dart'; // 🛠️ Import AppColors terpusat
import 'tambah_article.dart';
import 'package:image_picker/image_picker.dart'; // 👈 Menggunakan Image Picker yang sudah ada


class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});


  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}


class _ArticleScreenState extends State<ArticleScreen> {
  String role = "user";
  final TextEditingController searchC = TextEditingController();
  String searchQuery = "";


  @override
  void initState() {
    super.initState();
    loadRole();
  }


  Future<void> loadRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();


        if (doc.exists) {
          setState(() {
            role = doc.data()?['role'] ?? 'user';
          });
        }
      }
    } catch (e) {
      debugPrint("Role Error: $e");
    }
  }


  void openDetail(DocumentSnapshot article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(article: article, role: role),
      ),
    );
  }


  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eksplorasi Artikel",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.gradientStart,
        foregroundColor: AppColors.pinkDark,
        centerTitle: true,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      floatingActionButton: role == "admin"
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.pinkAccent,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 4,
              icon: const Icon(Icons.add_rounded),
              label: const Text("Artikel"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TambahArticleScreen(),
                  ),
                );
              },
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: searchC,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Cari artikel kesehatan mental...",
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.pinkAccent,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('articles')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Terjadi kesalahan, coba lagi nanti."),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.pinkAccent),
                    ),
                  );
                }


                final allArticles = snapshot.data!.docs;


                final articles = allArticles.where((article) {
                  final data = article.data() as Map<String, dynamic>;


                  final title = (data['title'] ?? '').toString().toLowerCase();
                  final content = (data['content'] ?? '')
                      .toString()
                      .toLowerCase();
                  final category = (data['category'] ?? '')
                      .toString()
                      .toLowerCase();


                  return title.contains(searchQuery) ||
                      content.contains(searchQuery) ||
                      category.contains(searchQuery);
                }).toList();


                if (articles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Belum ada artikel untuk dibaca",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }


                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    final data = article.data() as Map<String, dynamic>;
                    final String imageBase64 = data['imageBase64'] ?? '';


                    // 🛠️ FIX: Dekode Base64 untuk list card agar tidak error
                    Uint8List? imageBytes;
                    if (imageBase64.isNotEmpty) {
                      try {
                        imageBytes = base64Decode(imageBase64);
                      } catch (e) {
                        debugPrint("Decode List Image Error: $e");
                      }
                    }


                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.pinkPrimary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => openDetail(article),
                        child: Column(
                          // 🛠️ FIX: Mengubah dari Row ke Column agar proporsional dan tidak overflow
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'art_img_${article.id}',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Container(
                                  height: 160,
                                  width: double.infinity,
                                  color: AppColors.gradientEnd,
                                  child: imageBytes != null
                                      ? Image.memory(
                                          imageBytes,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                          errorBuilder: (_, __, ___) {
                                            return const Icon(
                                              Icons.broken_image_rounded,
                                              size: 48,
                                              color: AppColors.pinkAccent,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 48,
                                          color: AppColors.pinkAccent,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.gradientStart,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      data['category'] ?? 'Umum',
                                      style: const TextStyle(
                                        color: AppColors.pinkDark,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data['title'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.pinkDark,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.edit_note_rounded,
                                        size: 16,
                                        color: AppColors.textSecondary
                                            .withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          data['author'] ?? 'Anonim',
                                          style: TextStyle(
                                            color: AppColors.textSecondary
                                                .withOpacity(0.8),
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class ArticleDetailScreen extends StatelessWidget {
  final DocumentSnapshot article;
  final String role;


  const ArticleDetailScreen({
    super.key,
    required this.article,
    required this.role,
  });


  Future<void> _konfirmasiHapus(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Artikel?"),
        content: const Text("Artikel yang dihapus tidak dapat dikembalikan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );


    if (konfirmasi == true) {
      try {
        await FirebaseFirestore.instance
            .collection('articles')
            .doc(article.id)
            .delete();
        if (context.mounted) {
          Navigator.pop(context); // Kembali ke ArticleScreen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Artikel berhasil dihapus")),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menghapus artikel: $e")),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final data = article.data() as Map<String, dynamic>;
    Uint8List? imageBytes;


    try {
      final imageBase64 = data['imageBase64']?.toString() ?? '';
      if (imageBase64.isNotEmpty) {
        imageBytes = base64Decode(imageBase64);
      }
    } catch (e) {
      debugPrint("Decode Error: $e");
    }


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Baca Artikel",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.pinkDark,
        elevation: 0,
        centerTitle: true,
        actions: role == "admin"
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditArticleScreen(article: article),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () => _konfirmasiHapus(context),
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'art_img_${article.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Container(
                  height: 240,
                  width: double.infinity,
                  color: AppColors.gradientEnd,
                  // 🛠️ FIX: Menggunakan logika pembacaan imageBytes Base64 yang konsisten
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image_rounded,
                            size: 64,
                            color: AppColors.pinkAccent,
                          ),
                        )
                      : const Icon(
                          Icons.image_not_supported_rounded,
                          size: 64,
                          color: AppColors.pinkAccent,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pinkPrimary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      data['category'] ?? 'Umum',
                      style: const TextStyle(
                        color: AppColors.pinkDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['title'] ?? '-',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pinkDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.gradientEnd,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 18,
                          color: AppColors.pinkAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Ditulis oleh: ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        data['author'] ?? 'Anonim',
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFFFE4E1),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pinkPrimary.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      data['content'] ?? '-',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 2,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class EditArticleScreen extends StatefulWidget {
  final DocumentSnapshot article;
  const EditArticleScreen({super.key, required this.article});


  @override
  State<EditArticleScreen> createState() => _EditArticleScreenState();
}


class _EditArticleScreenState extends State<EditArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleC;
  late TextEditingController _categoryC;
  late TextEditingController _authorC;
  late TextEditingController _contentC;
  bool _isLoading = false;


  // Variabel untuk menampung data gambar biner & string Base64 terbaru
  Uint8List? _imageBytes;
  String _imageBase64String = "";


  // Menginisialisasi objek ImagePicker
  final ImagePicker _imagePicker = ImagePicker();


  @override
  void initState() {
    super.initState();
    final data = widget.article.data() as Map<String, dynamic>;
    _titleC = TextEditingController(text: data['title']);
    _categoryC = TextEditingController(text: data['category']);
    _authorC = TextEditingController(text: data['author']);
    _contentC = TextEditingController(text: data['content']);


    // Memuat string gambar lama dari Firestore jika tersedia
    _imageBase64String = data['imageBase64'] ?? '';
    if (_imageBase64String.isNotEmpty) {
      try {
        _imageBytes = base64Decode(_imageBase64String.trim());
      } catch (e) {
        debugPrint("Gagal memuat gambar awal: $e");
      }
    }
  }


  // Fungsi untuk memicu sistem galeri bawaan perangkat
  Future<void> _pilihGambarDariGaleri() async {
    try {
      final XFile? fileTerpilih = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality:
            70, // Kompresi gambar 70% agar performa Firestore tetap optimal
      );


      if (fileTerpilih != null) {
        final Uint8List bytes = await fileTerpilih.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageBase64String = base64Encode(
            bytes,
          ); // Otomatis mengonversi ke String Base64
        });
      }
    } catch (e) {
      debugPrint("Kesalahan mengambil gambar dari galeri: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal mengambil gambar: $e")));
      }
    }
  }


  @override
  void dispose() {
    _titleC.dispose();
    _categoryC.dispose();
    _authorC.dispose();
    _contentC.dispose();
    super.dispose();
  }


  Future<void> _updateArticle() async {
    if (!_formKey.currentState!.validate()) return;


    setState(() => _isLoading = true);


    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.article.id)
          .update({
            'title': _titleC.text.trim(),
            'category': _categoryC.text.trim(),
            'author': _authorC.text.trim(),
            'content': _contentC.text.trim(),
            'imageBase64':
                _imageBase64String, // Menyimpan string Base64 hasil pick dari galeri
            'updatedAt': FieldValue.serverTimestamp(),
          });


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Artikel sukses diperbarui!")),
        );
        Navigator.pop(context); // Menutup halaman edit
        Navigator.pop(context); // Kembali ke list utama agar memuat state segar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memperbarui: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.pinkAccent),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.pinkPrimary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.pinkPrimary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.pinkAccent, width: 1.5),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Edit Artikel",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.pinkDark,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.pinkAccent),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- SEKSI KLIK GAMBAR UNTUK BUKA GALERI ---
                    Text(
                      "Gambar Sampul (Ketuk gambar untuk mengganti)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pinkDark.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.pinkPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap:
                            _pilihGambarDariGaleri, // 👈 Pemicu galeri saat wadah gambar ditekan
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 190,
                            width: double.infinity,
                            color: AppColors.gradientEnd,
                            child: Stack(
                              children: [
                                // Layer Render Gambar Utama
                                Positioned.fill(
                                  child: _imageBytes != null
                                      ? Image.memory(
                                          _imageBytes!,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.image_not_supported_rounded,
                                            size: 54,
                                            color: AppColors.pinkAccent,
                                          ),
                                        ),
                                ),
                                // Layer Penunjuk (Overlay) Interaksi Galeri di Bagian Bawah Gambar
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.45),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.photo_library_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Ganti Gambar dari Galeri",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
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
                    const SizedBox(height: 24),


                    // --- STRUKTUR FORM ISIAN TEKS ---
                    TextFormField(
                      controller: _titleC,
                      decoration: _inputStyle(
                        "Judul Artikel",
                        Icons.title_rounded,
                      ),
                      validator: (v) => v!.isEmpty ? "Judul wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _categoryC,
                      decoration: _inputStyle(
                        "Kategori (Contoh: Anxiety, Mood)",
                        Icons.category_rounded,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Kategori wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _authorC,
                      decoration: _inputStyle(
                        "Nama Penulis",
                        Icons.create_rounded,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Penulis wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentC,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText:
                            "Tulis isi artikel kesehatan mental di sini...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.pinkPrimary.withOpacity(0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.pinkPrimary.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.pinkAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Isi artikel tidak boleh kosong" : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _updateArticle,
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}



