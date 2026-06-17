# MOMIND: Kesehatan Mental Ibu Double Job

## 1. Nama Aplikasi

**MOMIND**

## 2. Nama dan NPM Anggota Kelompok

| No | Nama                     | NPM         |
| -- | ------------------------ | ----------- |
| 1  | Mochamad Rico Andreano   | 24082010005 |
| 2  | Sisilia Roudhotun Nabila | 24082010009 |
| 3  | Vera Putri Priandini     | 24082010010 |
| 4  | Ainur Rohmah             | 24082010030 |
| 5  | Balqis Safira            | 24082010037 |

## 3. Tema Aplikasi

### Kesehatan Mental Ibu Double Job

Aplikasi ini berfokus pada pemantauan kesehatan mental ibu yang menjalani lebih dari satu pekerjaan (double job), baik pekerjaan formal maupun usaha sampingan.

## 4. Deskripsi Singkat Aplikasi

MoMind adalah aplikasi mobile berbasis Flutter yang membantu ibu dengan double job untuk memantau kondisi emosional dan kesehatan mental mereka setiap hari.

Aplikasi menyediakan fitur pencatatan mood, diary harian, artikel edukasi kesehatan mental, serta profil pengguna. Dengan aplikasi ini, pengguna dapat lebih memahami kondisi emosionalnya dan memperoleh informasi yang bermanfaat untuk menjaga keseimbangan antara pekerjaan dan kehidupan pribadi.

## 5. Jenis Firebase yang Digunakan

### Cloud Firestore

Firebase digunakan sebagai database utama untuk menyimpan data pengguna, mood tracking, diary, dan artikel.

## 6. Struktur Koleksi Firebase

### Collection: users

| Field     | Tipe Data |
| --------- | --------- |
| name      | string    |
| role      | string    |
| email     | string    |
| createdAt | timestamp |

### Collection: moods

| Field     | Tipe Data |
| --------- | --------- |
| userId    | string    |
| reason    | string    |
| moodScore | int       |
| mood      | string    |
| createdAt | timestamp |

### Collection: diaries

| Field     | Tipe Data |
| --------- | --------- |
| content   | string    |
| createdAt | timestamp |
| title     | string    |
| userId    | string    |

### Collection: articles

| Field       | Tipe Data |
| ----------- | --------- |
| author      | string    |
| category    | string    |
| content     | string    |
| createdAt   | timestamp |
| imageBase64 | string    |
| title       | string    |
| updatedAt   | timestamp |

## 7. Jumlah Data yang Digunakan

| Jenis Data | Jumlah      |
| ---------- | ----------- |
| Artikel    | 10 Data     |
| Mood       | 10 Data     |
| Diary      | 10 Data     |
| Users      | 5 Data      |
| **Total**  | **35 Data** |

## 8. Fitur Utama Aplikasi

### a. Home

Menampilkan ringkasan informasi dan navigasi utama aplikasi.

### b. Mood Tracker

Mencatat dan memantau kondisi suasana hati pengguna setiap hari.

### c. Diary

Menyimpan catatan harian pengguna terkait aktivitas dan kondisi emosional.

### d. Artikel

Pada user dengan role user, artikel adalah fitur yang menyediakan informasi dan edukasi mengenai kesehatan mental. Sedangkan pada user dengan role admin bisa CRUD artikel.

### e. Profil

Menampilkan dan mengelola informasi akun pengguna (foto, nama, informasi count jumlah diary dan mood)

## 9. Screenshot Aplikasi

### Halaman Home

<img width="385" height="801" alt="image" src="https://github.com/user-attachments/assets/2c400bdc-ad4c-4ca3-9f5d-a19740ac4a89" />

### Halaman Mood Tracker

<img width="387" height="799" alt="image" src="https://github.com/user-attachments/assets/4ed394b1-3678-436c-937b-0241b67c2555" />

### Halaman Artikel

<img width="392" height="792" alt="image" src="https://github.com/user-attachments/assets/88444a98-7b5f-4d25-afa3-b9d5748555ed" />

### Halaman Diary

<img width="386" height="798" alt="image" src="https://github.com/user-attachments/assets/354b2734-5a2e-4745-982b-864f9ac87838" />

### Halaman Profil

<img width="377" height="795" alt="image" src="https://github.com/user-attachments/assets/7ecb5bf6-1805-4542-93fc-92aa4fe364b1" />

## 10. Cara Menjalankan Aplikasi

### Clone Repository

```bash
git clone https://github.com/24082010005-cmyk/MoMind_Team.git
```
### Masuk ke Folder Project

```bash
cd MoMind_Team
```

### Install Dependency

```bash
flutter pub get
```

### Jalankan Aplikasi

```bash
flutter run
```

## Teknologi yang Digunakan

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Material Design

## 11. Penggunaan AI

Dalam proses pengembangan aplikasi MoMind, tim memanfaatkan teknologi Artificial Intelligence (AI) secara intensif sebagai alat bantu dalam berbagai tahapan pengembangan, mulai dari pencarian referensi, penyusunan dokumentasi, brainstorming ide fitur, perancangan antarmuka, pembangunan kode program, hingga proses debugging dan penyelesaian error. Pemanfaatan AI memberikan kontribusi yang sangat besar terhadap efisiensi dan percepatan proses pengembangan aplikasi.

Meskipun penggunaan AI dilakukan secara masif selama proses pengembangan, tim tidak hanya menerima hasil yang diberikan secara langsung. Setiap saran, potongan kode, maupun solusi yang dihasilkan AI tetap dipelajari, dianalisis, diuji, dan disesuaikan dengan kebutuhan aplikasi. Ketika ditemukan error atau kendala teknis, tim berupaya memahami penyebab permasalahan, mempelajari konsep yang terkait, serta melakukan perbaikan secara mandiri dengan memanfaatkan AI sebagai pendamping belajar dan pengembangan.

## Mata Kuliah

**Pemrograman Mobile**

Program Studi Sistem Informasi
Fakultas Ilmu Komputer
UPN "Veteran" Jawa Timur

Tahun 2025/2026
