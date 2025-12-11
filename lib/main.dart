import 'package:flutter/material.dart';
import 'beranda.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kemahasiswaan',
      theme: ThemeData(
        // Tema global diset ke Pink
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 240, 98, 146), 
        ),
        useMaterial3: true,
      ),
      home: const HalamanDepan(),
    );
  }
}

class HalamanDepan extends StatelessWidget {
  const HalamanDepan({super.key});

  @override
  Widget build(BuildContext context) {
    // --- WARNA TEMA SOFT PINK ---
    const Color primaryColor = Color.fromARGB(255, 240, 98, 146); 

    return Scaffold(
      backgroundColor: primaryColor, // Background Pink
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/upgris.png', // Pastikan ekstensi sesuai file (.png atau .jpg)
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 35),

              // JUDUL
              const Text(
                "FORUM MAHASISWA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white, // Teks Putih di atas Pink
                  letterSpacing: 1.2,
                ),
              ),

              // Teks slogan "Berkarya..." sudah dihapus di sini

              const SizedBox(height: 50),

              // TOMBOL MASUK 
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Tombol Putih
                    foregroundColor: primaryColor, // Teks Tombol Pink
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Beranda()),
                    );
                  },
                  child: const Text(
                    "MASUK APLIKASI",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
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