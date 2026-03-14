import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:masjid_berhasil/model/admin/news_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class FormBerita extends StatefulWidget {
  final Berita? berita;

  const FormBerita({super.key, this.berita});

  @override
  State<FormBerita> createState() => _FormBeritaState();
}

class _FormBeritaState extends State<FormBerita> {
  final judul = TextEditingController();
  final tanggal = TextEditingController();
  final clickbait = TextEditingController();
  final artikel = TextEditingController();

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      final formatted = DateFormat('dd MMMM yyyy', 'id_ID').format(picked);

      setState(() {
        tanggal.text = formatted;
      });
    }
  }

  File? imageFile;
  final picker = ImagePicker();
  bool isLoading = false;

  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://masjid-at-taufiq-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("news");

  @override
  void initState() {
    super.initState();

    if (widget.berita != null) {
      judul.text = widget.berita!.judul;
      tanggal.text = widget.berita!.tanggal;
      clickbait.text = widget.berita!.clickbait;
      artikel.text = widget.berita!.isi;
    }
  }

  /// PILIH GAMBAR
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  /// UPLOAD FOTO KE FIREBASE STORAGE
  Future<String> uploadFoto() async {
    if (imageFile == null) {
      return widget.berita?.foto ?? "";
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final refStorage = FirebaseStorage.instance.ref().child(
      "news_images/$fileName.jpg",
    );

    await refStorage.putFile(imageFile!);

    final url = await refStorage.getDownloadURL();

    return url;
  }

  /// SIMPAN DATA
  Future<void> simpan() async {
    setState(() => isLoading = true);

    String fotoUrl = await uploadFoto();

    String id = widget.berita?.id ?? ref.push().key!;

    final berita = Berita(
      id: id,
      judul: judul.text,
      tanggal: tanggal.text,
      clickbait: clickbait.text,
      isi: artikel.text,
      foto: fotoUrl,
    );

    await ref.child(id).set(berita.toMap());

    setState(() => isLoading = false);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.berita != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Berita" : "Tambah Berita")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            /// FOTO
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                  image: imageFile != null
                      ? DecorationImage(
                          image: FileImage(imageFile!),
                          fit: BoxFit.cover,
                        )
                      : (widget.berita != null &&
                            widget.berita!.foto.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(widget.berita!.foto),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child:
                    imageFile == null &&
                        (widget.berita == null || widget.berita!.foto.isEmpty)
                    ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: judul,
              decoration: const InputDecoration(labelText: "Judul"),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: tanggal,
              readOnly: true,
              onTap: pickDate,
              focusNode: FocusNode(),
              decoration: const InputDecoration(
                labelText: "Tanggal",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: clickbait,
              decoration: const InputDecoration(labelText: "Clickbait"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: artikel,
              decoration: const InputDecoration(labelText: "Artikel"),
              maxLines: 5,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : simpan,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isEdit ? "Update Berita" : "Simpan Berita"),
            ),
          ],
        ),
      ),
    );
  }
}
