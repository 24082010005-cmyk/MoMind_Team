import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_colors.dart'; // 🛠️ TAMBAHAN: Mengintegrasikan AppColors terpusat
import 'diary_detail_screen.dart';


class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});


  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}


class _DiaryScreenState extends State<DiaryScreen> {
  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();


  final TextEditingController searchC = TextEditingController();
  String searchQuery = "";


  bool loading = false;


  Future<void> saveDiary() async {
    if (titleC.text.trim().isEmpty || contentC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Judul dan isi diary wajib diisi, ya! 📝"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }


    setState(() {
      loading = true;
    });


    try {
      await FirebaseFirestore.instance.collection("diaries").add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "title": titleC.text.trim(),
        "content": contentC.text.trim(),
        "createdAt": Timestamp.now(),
      });


      titleC.clear();
      contentC.clear();


      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ceritamu berhasil disimpan dengan aman ✨"),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Waduh, ada kendala: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }


    setState(() {
      loading = false;
    });
  }


  Future<void> deleteDiary(String docId) async {
    await FirebaseFirestore.instance.collection("diaries").doc(docId).delete();


    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Catatan diary berhasil dihapus"),
        backgroundColor: AppColors.textMain,
      ),
    );
  }


  @override
  void dispose() {
    titleC.dispose();
    contentC.dispose();
    searchC.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Ruang Cerita",
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
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // 🛠️ FORM INPUT BERGAYA MEMO CATATAN
                TextField(
                  controller: titleC,
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: InputDecoration(
                    labelText: "Judul Cerita Hari Ini...",
                    prefixIcon: const Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.pinkAccent,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.pinkPrimary.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentC,
                  maxLines: 4,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        "Tumpahkan semua emosi atau pikiranmu di sini...",
                    prefixIcon: const Icon(
                      Icons.auto_stories_rounded,
                      color: AppColors.pinkAccent,
                    ),
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.pinkPrimary.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),


                // 🛠️ TOMBOL SIMPAN ELEGAN
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : saveDiary,
                    icon: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.favorite_rounded, size: 20),
                    label: Text(
                      loading ? "Mengunci Diary..." : "Simpan di Diary Rahasia",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pinkAccent,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 28),


                // SUB-HEADER RIWAYAT DIARY
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.pinkAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Lembar Cerita Lamamu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pinkDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),


                TextField(
                  controller: searchC,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Cari diary...",
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.pinkAccent,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),


                const SizedBox(height: 12),


                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("diaries")
                      .where("userId", isEqualTo: uid)
                      .orderBy("createdAt", descending: true)
                      .limit(50)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: AppColors.error),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.pinkAccent,
                          ),
                        ),
                      );
                    }


                    final allDocs = snapshot.data?.docs ?? [];


                    final docs = allDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;


                      final title = (data["title"] ?? "")
                          .toString()
                          .toLowerCase();


                      final content = (data["content"] ?? "")
                          .toString()
                          .toLowerCase();


                      return title.contains(searchQuery) ||
                          content.contains(searchQuery);
                    }).toList();


                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: 56,
                              color: AppColors.textSecondary.withOpacity(0.25),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Belum ada lembar cerita tersimpan.\nMulai ketik harimu di atas!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.8),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }


                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;


                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: AppColors.pinkPrimary.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DiaryDetailScreen(
                                    title: data["title"] ?? "-",
                                    content: data["content"] ?? "-",
                                    createdAt: data["createdAt"],
                                  ),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.gradientStart,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.book_rounded,
                                color: AppColors.pinkDark,
                                size: 22,
                              ),
                            ),
                            title: Text(
                              data["title"] ?? "-",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                data["content"] ?? "-",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.textSecondary.withOpacity(0.6),
                                size: 22,
                              ),
                              onPressed: () => deleteDiary(doc.id),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



