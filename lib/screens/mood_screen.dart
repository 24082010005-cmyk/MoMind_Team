import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_colors.dart'; // 🛠️ TAMBAHAN: Integrasi AppColors terpusat


class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});


  @override
  State<MoodScreen> createState() => _MoodScreenState();
}


class _MoodScreenState extends State<MoodScreen> {
  final TextEditingController reasonC = TextEditingController();


  String selectedMood = "";
  int moodScore = 0;
  bool loading = false;


  Future<void> saveMood() async {
    if (selectedMood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih salah satu emoji mood-mu dulu ya! 🌸"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }


    setState(() {
      loading = true;
    });


    try {
      await FirebaseFirestore.instance.collection("moods").add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "mood": selectedMood,
        "moodScore": moodScore,
        "reason": reasonC.text.trim(),
        "createdAt": Timestamp.now(),
      });


      reasonC.clear();


      setState(() {
        selectedMood = "";
        moodScore = 0;
      });


      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Catatan suasana hatimu berhasil direkam ✨"),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan mood: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }


    setState(() {
      loading = false;
    });
  }


  // 🛠️ REDESAIN: Tombol Pilihan Mood Interaktif ala Kartu Catatan
  Widget moodButton(String emoji, String mood, int score) {
    bool selected = selectedMood == mood;


    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
          moodScore = score;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.gradientStart : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.pinkAccent
                : AppColors.pinkPrimary.withOpacity(0.15),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.pinkAccent.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              mood,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? AppColors.pinkDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildMoodChart(List<QueryDocumentSnapshot> docs) {
    final moods = docs.reversed.toList();


    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.pinkPrimary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Perkembangan Mood",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.pinkDark,
            ),
          ),
          const SizedBox(height: 16),


          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: moods.map((doc) {
                final data = doc.data() as Map<String, dynamic>;


                final score = (data["moodScore"] ?? 0).toDouble();


                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: score * 20,
                          decoration: BoxDecoration(
                            color: AppColors.pinkAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          score.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


  String getEmoji(String mood) {
    switch (mood) {
      case "Sangat Bahagia":
        return "😁";
      case "Bahagia":
        return "😊";
      case "Netral":
        return "😐";
      case "Sedih":
        return "😔";
      case "Sangat Sedih":
        return "😭";
      default:
        return "🙂";
    }
  }


  @override
  void dispose() {
    reasonC.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Pelacak Suasana Hati",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🛠️ PERBAIKAN: Mengisolasi form input atas agar bisa menciut/scroll secara aman saat keyboard aktif
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          "Bagaimana perasaanmu saat ini?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pinkDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),


                      // Layout Wrap Grid Horizontal untuk tombol Mood
                      Center(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            moodButton("😁", "Sangat Bahagia", 5),
                            moodButton("😊", "Bahagia", 4),
                            moodButton("😐", "Netral", 3),
                            moodButton("😔", "Sedih", 2),
                            moodButton("😭", "Sangat Sedih", 1),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),


                      // TEXTFIELD FORM
                      TextField(
                        controller: reasonC,
                        maxLines: 2,
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText:
                              "Cerita singkat di balik mood-mu hari ini...",
                          prefixIcon: const Icon(
                            Icons.bubble_chart_rounded,
                            color: AppColors.pinkAccent,
                          ),
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.pinkAccent,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.pinkPrimary.withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.pinkAccent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),


                      // TOMBOL REKAM DATA MOOD
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: loading ? null : saveMood,
                          icon: loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.wb_sunny_rounded, size: 20),
                          label: Text(
                            loading ? "Mencatat..." : "Simpan Evaluasi Energi",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pinkAccent,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),


                // SUB HEADER RIWAYAT MOOD (Tetap di posisinya)
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.pinkAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Jejak Langkah Emosimu",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pinkDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),


                // DAFTAR RIWAYAT MOOD (Mengisi sisa area layar secara fleksibel)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("moods")
                      .where("userId", isEqualTo: uid)
                      .orderBy("createdAt", descending: true)
                      .limit(7)
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


                    final docs = snapshot.data?.docs ?? [];
                    final chartDocs = docs;


                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wb_twilight_rounded,
                              size: 56,
                              color: AppColors.textSecondary.withOpacity(0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Belum ada catatan grafik emosimu.\nEkspresikan hari ini di atas!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }


                    return Column(
                      children: [
                        buildMoodChart(chartDocs),


                        ...docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;


                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: AppColors.pinkPrimary.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              leading: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.gradientStart.withOpacity(
                                    0.6,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  getEmoji(data["mood"]),
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              title: Text(data["mood"] ?? "-"),
                              subtitle: Text(
                                (data["reason"] == null ||
                                        data["reason"].toString().isEmpty)
                                    ? "Tidak ada catatan alasan khusus."
                                    : data["reason"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gradientStart,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text("⭐ ${data["moodScore"]}"),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
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



