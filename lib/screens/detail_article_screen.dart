import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import '../app_colors.dart';


class ArticleDetail extends StatelessWidget {
  final Map<String, dynamic> data;


  const ArticleDetail({super.key, required this.data});


  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;


    try {
      final imageBase64 = data['imageBase64']?.toString() ?? '';


      if (imageBase64.isNotEmpty) {
        imageBytes = base64Decode(imageBase64);
      }
    } catch (e) {
      debugPrint("Image Decode Error: $e");
    }


    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          "Baca Artikel",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.pinkDark,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.pinkAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 220,
                            gaplessPlayback: true,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  size: 60,
                                  color: Colors.red,
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_not_supported_rounded,
                              size: 60,
                              color: AppColors.pinkAccent,
                            ),
                          ),
                  ),
                ),


                const SizedBox(height: 20),


                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pinkAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['category'] ?? 'Umum',
                    style: const TextStyle(
                      color: AppColors.pinkDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),


                const SizedBox(height: 12),


                Text(
                  data['title'] ?? 'Tanpa Judul',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkDark,
                    height: 1.3,
                  ),
                ),


                const SizedBox(height: 12),


                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.pinkAccent.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: AppColors.pinkDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Ditulis oleh: ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data['author'] ?? 'Anonim',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 16),


                Divider(color: Colors.grey.shade200, thickness: 1.5),


                const SizedBox(height: 16),


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    data['content'] ?? 'Tidak ada isi konten.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textMain,
                      height: 1.6,
                    ),
                  ),
                ),


                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



