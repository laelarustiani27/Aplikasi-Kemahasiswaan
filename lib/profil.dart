import 'package:flutter/material.dart';

class HalamanProfil extends StatelessWidget {
  final String nama;
  final String alamat;
  final String npm;
  final String prodi;
  final String kelas;
  final String jk;

  const HalamanProfil({
    super.key,
    required this.nama,
    required this.alamat,
    required this.npm,
    required this.prodi,
    required this.kelas,
    required this.jk,
  });

  @override
  Widget build(BuildContext context) {
    // --- WARNA TEMA (Sama dengan Beranda) ---
    final Color primaryColor = const Color.fromARGB(255, 240, 98, 146);
    
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background dasar putih gading
      body: Stack(
        children: [
          // 1. BACKGROUND HEADER (Pink Melengkung)
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. KONTEN
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // HEADER CUSTOM: Tombol Back & Judul
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          "DATA MAHASISWA",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Penyeimbang layout (dummy)
                    ],
                  ),

                  const SizedBox(height: 30),

                  // FOTO PROFIL (Avatar Besar)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: primaryColor),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // NAMA & STATUS 
                  Text(
                    nama.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Text(
                    "Mahasiswa Aktif",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // KARTU DATA (Floating Card)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List Data
                        buildDetailItem("NPM", npm, Icons.badge_outlined, primaryColor),
                        buildDetailItem("Program Studi", prodi, Icons.school_outlined, primaryColor),
                        buildDetailItem("Kelas", kelas, Icons.class_outlined, primaryColor),
                        buildDetailItem("Jenis Kelamin", jk, Icons.wc_outlined, primaryColor),
                        buildDetailItem("Alamat", alamat, Icons.location_on_outlined, primaryColor),
                        
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        // TOMBOL SELESAI
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              shadowColor: Colors.white.withValues(alpha: 0.7),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "SELESAI",
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 80), // Jarak ekstra agar tidak tertutup tombol tambah
                ],
              ),
            ),
          ),
        ],
      ),

      // TOMBOL TAMBAH DATA (INI YANG KEMBALI SAYA TAMBAHKAN)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: 'Input Data Lagi',
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  // WIDGET ITEM DATA
  Widget buildDetailItem(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon dalam kotak kecil
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 15),
          
          // Label dan Isi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? "-" : value, 
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}