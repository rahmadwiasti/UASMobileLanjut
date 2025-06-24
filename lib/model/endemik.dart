class Endemik {
  final String id;
  final String nama;
  final String namaLatin;
  final String deskripsi;
  final String asal;
  final String foto;
  final String status;
  final String isFavorit;

  Endemik({
    required this.id,
    required this.nama,
    required this.namaLatin,
    required this.deskripsi,
    required this.asal,
    required this.foto,
    required this.status,
    required this.isFavorit,
  });

  factory Endemik.fromJson(Map<String, dynamic> json) => Endemik(
    id: json['id'],
    nama: json['nama'],
    namaLatin: json['nama_latin'],
    deskripsi: json['deskripsi'],
    asal: json['asal'],
    foto: json['foto'],
    status: json['status'],
    isFavorit: json['is_favorit'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nama': nama,
    'nama_latin': namaLatin,
    'deskripsi': deskripsi,
    'asal': asal,
    'foto': foto,
    'status': status,
    'is_favorit': isFavorit,
  };

  factory Endemik.fromMap(Map<String, dynamic> map) => Endemik(
    id: map['id'],
    nama: map['nama'],
    namaLatin: map['nama_latin'],
    deskripsi: map['deskripsi'],
    asal: map['asal'],
    foto: map['foto'],
    status: map['status'],
    isFavorit: map['is_favorit'],
  );
}
