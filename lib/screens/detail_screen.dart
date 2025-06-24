import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../db/database_helper.dart';
import 'image_view_screen.dart'; // ← import layar gambar

class DetailScreen extends StatefulWidget {
  final Endemik data;
  const DetailScreen({super.key, required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorit = false;

  @override
  void initState() {
    super.initState();
    isFavorit = widget.data.isFavorit == "true";
  }

  void toggleFavorit() async {
    final newValue = !isFavorit;
    await DatabaseHelper().setFavorit(widget.data.id, newValue.toString());
    setState(() => isFavorit = newValue);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.nama),
        actions: [
          IconButton(
            icon: Icon(isFavorit ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorit,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewScreen(imageUrl: data.foto),
                ),
              );
            },
            child: Hero( // untuk transisi halus
              tag: data.foto,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(data.foto),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(data.namaLatin, style: const TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(data.deskripsi),
          const SizedBox(height: 16),
          Text("Asal: ${data.asal}"),
          const SizedBox(height: 8),
          Text("Status konservasi: ${data.status}"),
        ],
      ),
    );
  }
}
