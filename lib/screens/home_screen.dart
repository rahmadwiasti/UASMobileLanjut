import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../db/database_helper.dart';
import 'favorite_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Endemik>> futureEndemik;

  @override
  void initState() {
    super.initState();
    futureEndemik = DatabaseHelper().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EndemikDB")),
      body: FutureBuilder<List<Endemik>>(
        future: futureEndemik,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          } else {
            final data = snapshot.data!;
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(data: item),
                    ),
                  ),
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            item.foto,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          item.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorit"),
        ],
      ),
    );
  }
}