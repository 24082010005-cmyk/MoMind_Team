import 'package:flutter/material.dart';
import '../app_colors.dart'; // 🛠️ TAMBAHAN: Import AppColors agar warna sinkron


class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;


  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      // 🛠️ TAMBAHAN: Dekorasi Container agar Navbar memiliki bayangan lembut dan sudut melengkung halus
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -4), // Bayangan mengarah ke atas
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,


          // 🛠️ PERBAIKAN: Menggunakan warna estetik terpusat dari MoMind Theme
          selectedItemColor: AppColors.pinkAccent,
          unselectedItemColor: AppColors.textSecondary.withOpacity(0.5),
          backgroundColor: Colors.white,


          // Gaya teks label saat aktif dan tidak aktif
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),


          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
              ), // Menggunakan versi rounded agar lebih ramah & estetik
              activeIcon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood_rounded),
              activeIcon: Icon(Icons.mood_rounded),
              label: "Mood",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              activeIcon: Icon(Icons.book_rounded),
              label: "Diary",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_rounded),
              activeIcon: Icon(Icons.article_rounded),
              label: "Artikel",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}



