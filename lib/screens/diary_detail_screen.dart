import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_colors.dart';


class DiaryDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final Timestamp? createdAt;


  const DiaryDetailScreen({
    super.key,
    required this.title,
    required this.content,
    this.createdAt,
  });


  @override
  Widget build(BuildContext context) {
    final date = createdAt?.toDate();


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,


      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Diary Saya",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.gradientStart,
        foregroundColor: AppColors.pinkDark,
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),


        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),


          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),


            boxShadow: [
              BoxShadow(
                color: AppColors.pinkPrimary.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),


          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.gradientStart,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 34,
                    color: AppColors.pinkDark,
                  ),
                ),
              ),


              const SizedBox(height: 20),


              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),


              const SizedBox(height: 10),


              if (date != null)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),


                    const SizedBox(width: 6),


                    Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),


              const SizedBox(height: 20),


              Divider(color: AppColors.pinkPrimary.withOpacity(0.25)),


              const SizedBox(height: 20),


              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.9,
                  color: AppColors.textMain,
                ),
              ),


              const SizedBox(height: 40),


              Center(
                child: Text(
                  "🌸 Terima kasih sudah menuliskan perasaanmu hari ini 🌸",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.pinkDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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



