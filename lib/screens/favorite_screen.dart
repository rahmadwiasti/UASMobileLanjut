import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../db/database_helper.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Endemik>> favoriteData;

  @override
  void initState() {
    super.initState();
    favoriteData = DatabaseHelper().getFavoritAll();
  }

  Future<void> refreshData() async {
    setState(() {
      favoriteData = DatabaseHelper().getFavoritAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EndemikDB")),
      body: FutureBuilder<List<Endemik>>(
        future: favoriteData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal mengambil data"));
          } else {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(child: Text("Belum ada data favorit."));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final item = data[index];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailScreen(data: item)),
                    );
                    // refresh setelah kembali dari DetailScreen
                    refreshData();
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(child: Image.network(item.foto, fit: BoxFit.cover)),
                        Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await DatabaseHelper().deleteFavoritAll();
          refreshData();
        },
        label: const Text("Hapus"),
        icon: const Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }
}
