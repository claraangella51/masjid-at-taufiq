class Berita {
  String? id;
  String judul;
  String clickbait;
  String tanggal;
  String foto; // URL Firebase
  String isi;

  Berita({
    this.id,
    required this.judul,
    required this.clickbait,
    required this.tanggal,
    required this.foto,
    required this.isi,
  });

  Map<String, dynamic> toMap() {
    return {
      "judul": judul,
      "clickbait": clickbait,
      "tanggal": tanggal,
      "foto": foto,
      "isi": isi,
    };
  }

  factory Berita.fromMap(String id, Map<String, dynamic> map) {
    return Berita(
      id: id,
      judul: map["judul"] ?? "",
      clickbait: map["clickbait"] ?? "",
      tanggal: map["tanggal"] ?? "",
      foto: map["foto"] ?? "",
      isi: map["isi"] ?? "",
    );
  }
}
