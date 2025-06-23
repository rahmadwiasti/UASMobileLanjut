import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../model/endemik.dart';

class kenHomeScreen extends StatefulWidget {
  const kenHomeScreen({Key? key}) : super(key: key);

  @override
  State<kenHomeScreen> createState() => _kenHomeScreenState();
}

class _kenHomeScreenState extends State<kenHomeScreen> {
  List<Endemik> _listBurung = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBurung();
  }

  Future<void> _loadBurung() async {
    final data = await DatabaseHelper().getAll();
    setState(() {
      _listBurung = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EndemikDB'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listBurung.isEmpty
          ? const Center(child: Text('Belum ada data burung.'))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: _listBurung.length,
        itemBuilder: (context, index) {
          final burung = _listBurung[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset(
                      burung.foto,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    burung.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Nanti bisa tambahkan navigasi ke halaman favorit
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }
}
