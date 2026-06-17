import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_colors.dart'; // 🛠️ Integrasi AppColors terpusat
import 'mood_screen.dart';
import 'diary_screen.dart';
import 'article_screen.dart';
import 'relaxation_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  String userName = "Ibu Hebat";


  @override
  void initState() {
    super.initState();
    getUserData();
  }


  Future<void> getUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;


      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();


      if (doc.exists && mounted) {
        setState(() {
          userName = doc['name'] ?? "Ibu Hebat";
        });
      }
    } catch (e) {
      debugPrint("Error mengambil data user: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            "MoMind",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: 0.5,
              color: AppColors.pinkDark,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.pinkPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.pinkAccent,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌸 SECTION 1: SAMBUTAN HANGAT & PERSONAL
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, $userName ❤️",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pinkDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gradientStart.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Sudahkah kamu mengapresiasi dirimu hari ini?",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.pinkDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),


            // 🌸 SECTION 2: KARTU AFIRMASI POSITIF (Dibuat seperti Bubble Quote yang Fun)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    AppColors.gradientStart.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(32),
                ),
                border: Border.all(
                  color: AppColors.pinkPrimary.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pinkPrimary.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.format_quote_rounded,
                      size: 60,
                      color: AppColors.pinkPrimary.withOpacity(0.08),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.gradientStart,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.pinkAccent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Ruang Tenang Rihat",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.pinkDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "\"Luangkan waktu setidaknya 10 menit untuk bernapas lega sendirian. Istirahat sejenak bukanlah tanda menyerah, melainkan cara terbaik menjaga energi warasmu.\"",
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: AppColors.textMain,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),


            // INTERMEDIATE SUBHEADER
            Row(
              children: [
                const Text(
                  "Eksplorasi Ruangmu",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkDark,
                  ),
                ),
                const SizedBox(width: 6),
                Text("🚀", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 14),


            // 🌸 SECTION 3: MENU FITUR UTAMA (Warna-warni Pastel yang Fun)
            Column(
              children: [
                // Baris Pertama
                Row(
                  children: [
                    Expanded(
                      child: FeatureCard(
                        icon: Icons.sentiment_satisfied_alt_rounded,
                        title: "Mood Tracker",
                        desc: "Evaluasi Energi",
                        cardColor: const Color(0xFFFFEAEA), // Soft Peach/Pink
                        iconBgColor: const Color(0xFFFFC6C6),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MoodScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: FeatureCard(
                        icon: Icons.auto_stories_rounded,
                        title: "Diary Rahasia",
                        desc: "Tumpahkan Emosi",
                        cardColor: const Color(
                          0xFFE8E9F3,
                        ), // Soft Lavender/Blue
                        iconBgColor: const Color(0xFFC5C9E8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DiaryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Baris Kedua
                Row(
                  children: [
                    Expanded(
                      child: FeatureCard(
                        icon: Icons.import_contacts_rounded,
                        title: "Ruang Baca",
                        desc: "Artikel Edukasi",
                        cardColor: const Color(0xFFE1F4F3), // Soft Mint/Teal
                        iconBgColor: const Color(0xFFB2E3E0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ArticleScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: FeatureCard(
                        icon: Icons.spa_rounded,
                        title: "Relaksasi",
                        desc: "Tarik Napas",
                        cardColor: const Color(0xFFFFF2D4), // Soft Warm Yellow
                        iconBgColor: const Color(0xFFFFE094),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RelaxationScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),


            // 🌸 SECTION 4: LIVE PREVIEW - CATATAN HARIAN TERBARU
            Row(
              children: [
                Container(
                  width: 6,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.pinkAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Lembar Cerita Terakhirmu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkDark,
                  ),
                ),
                const SizedBox(width: 6),
                const Text("📝", style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 14),


            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("diaries")
                  .where("userId", isEqualTo: uid)
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.pinkAccent,
                        ),
                      ),
                    ),
                  );
                }


                final docs = snapshot.data?.docs ?? [];
                docs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;


                  final aTime = aData["createdAt"] as Timestamp?;
                  final bTime = bData["createdAt"] as Timestamp?;


                  if (aTime == null || bTime == null) return 0;


                  return bTime.compareTo(aTime);
                });


                if (docs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.pinkPrimary.withOpacity(0.12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text("✨", style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text(
                          "Belum ada cerita yang terukir.\nMulai tumpahkan perasaanmu di menu Diary!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }


                final lastDiary = docs.first.data() as Map<String, dynamic>;


                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.pinkPrimary.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              lastDiary["title"] ?? "-",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.pinkDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gradientStart,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "Terbaru",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.pinkDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        lastDiary["content"] ?? "-",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// 🛠️ FeatureCard yang Ditingkatkan dengan Custom Pastel Background & Animasi Klik yang Lembut
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color cardColor;
  final Color iconBgColor;
  final VoidCallback? onTap;


  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    this.cardColor = Colors.white,
    this.iconBgColor = AppColors.gradientStart,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          highlightColor: Colors.white.withOpacity(0.2),
          splashColor: Colors.white.withOpacity(0.1),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: AppColors.pinkDark),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.pinkDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
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



