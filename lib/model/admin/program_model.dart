class Program {
  int? id;
  String judul;
  String kategori;
  String waktu;

  Program({
    this.id,
    required this.judul,
    required this.kategori,
    required this.waktu,
  });

  Map<String, dynamic> toMap() {
    return {"id": id, "judul": judul, "kategori": kategori, "waktu": waktu};
  }

  factory Program.fromMap(Map<String, dynamic> map) {
    return Program(
      id: map["id"],
      judul: map["judul"],
      kategori: map["kategori"],
      waktu: map["waktu"],
    );
  }
}
