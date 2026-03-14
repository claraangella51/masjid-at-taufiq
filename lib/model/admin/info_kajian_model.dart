class Kajian {
  String? id; // key Firebase
  String judul;
  String tanggal;
  String poster;
  String pemateri;
  String deskripsi;

  Kajian({
    this.id,
    required this.judul,
    required this.tanggal,
    required this.poster,
    required this.pemateri,
    required this.deskripsi,
  });

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'tanggal': tanggal,
      'poster': poster,
      'pemateri': pemateri,
      'deskripsi': deskripsi,
    };
  }

  factory Kajian.fromMap(String id, Map<String, dynamic> map) {
    return Kajian(
      id: id,
      judul: map['judul'] ?? "",
      tanggal: map['tanggal'] ?? "",
      poster: map['poster'] ?? "",
      pemateri: map['pemateri'] ?? "",
      deskripsi: map['deskripsi'] ?? "",
    );
  }
}
