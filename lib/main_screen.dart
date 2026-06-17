import 'package:flutter/material.dart';


import 'screens/home_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/diary_screen.dart';
import 'screens/article_screen.dart';
import 'screens/profile_screen.dart';


import 'widgets/bottom_navbar.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;


  final List<Widget> _pages = const [
    HomeScreen(),
    MoodScreen(),
    DiaryScreen(),
    ArticleScreen(),
    ProfileScreen(),
  ];


  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🛠️ Menggunakan IndexedStack dipertahankan karena sangat bagus untuk menghemat state halaman
      body: IndexedStack(index: _currentIndex, children: _pages),


      // 🛠️ Menggunakan widget kustom BottomNavbar Anda
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _changePage,
      ),
    );
  }
}



