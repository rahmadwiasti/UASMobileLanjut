import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/database_helper.dart';
import '../model/endemik.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData(); // Panggil fungsi saat splash dimulai
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper();
    final count = await db.count();

    if (count == 0) {
      try {
        final response = await http.get(Uri.parse('https://hendroprwk08.github.io/data_endemik/endemik.json'));
        final List<dynamic> jsonData = json.decode(response.body);

        for (var json in jsonData) {
          final item = Endemik(
            id: json["id"],
            nama: json["nama"],
            namaLatin: json["nama_latin"],
            deskripsi: json["deskripsi"],
            asal: json["asal"],
            foto: json["foto"],
            status: json["status"],
            isFavorit: "false",
          );
          await db.insert(item);
        }

        print("✅ Data berhasil diambil dan dimasukkan ke database.");
      } catch (e) {
        print("❌ Gagal mengambil data: $e");
      }
    } else {
      print("📦 Data sudah ada di database.");
    }

    // Setelah load selesai, pindah ke home
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logo.png'), // Pastikan logo tersedia
              width: 150,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.purple),
            SizedBox(height: 10),
            Text(
              'Memuat data endemik...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
