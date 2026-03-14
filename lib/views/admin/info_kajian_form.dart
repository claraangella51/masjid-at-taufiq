import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:masjid_berhasil/model/admin/info_kajian_model.dart';

class KajianFormScreen extends StatefulWidget {
  final Kajian? kajian;

  const KajianFormScreen({super.key, this.kajian});

  @override
  State<KajianFormScreen> createState() => _KajianFormScreenState();
}

class _KajianFormScreenState extends State<KajianFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final judulController = TextEditingController();
  final pemateriController = TextEditingController();
  final deskripsiController = TextEditingController();
  final tanggalController = TextEditingController();
  bool isLoading = false;

  File? imageFile;
  final picker = ImagePicker();
  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://masjid-at-taufiq-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("kajian");

  @override
  void initState() {
    super.initState();
    if (widget.kajian != null) {
      judulController.text = widget.kajian!.judul;
      pemateriController.text = widget.kajian!.pemateri;
      deskripsiController.text = widget.kajian!.deskripsi;
      tanggalController.text = widget.kajian!.tanggal;
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

  /// DATE PICKER
  Future pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        tanggalController.text = DateFormat('dd MMMM yyyy').format(pickedDate);
      });
    }
  }

  /// UPLOAD KE FIREBASE STORAGE
  Future<String> uploadPoster() async {
    try {
      if (imageFile == null) {
        print("TIDAK ADA GAMBAR BARU");
        return widget.kajian?.poster ?? "";
      }

      final start = DateTime.now();
      print("UPLOAD START: $start");

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final refStorage = FirebaseStorage.instance.ref().child(
        "kajian_posters/$fileName.jpg",
      );

      UploadTask uploadTask = refStorage.putFile(imageFile!);

      uploadTask.snapshotEvents.listen((event) {
        double progress = (event.bytesTransferred / event.totalBytes) * 100;

        print("UPLOAD PROGRESS: ${progress.toStringAsFixed(0)}%");
      });

      TaskSnapshot snapshot = await uploadTask;

      final url = await snapshot.ref.getDownloadURL();

      final end = DateTime.now();
      print("UPLOAD END: $end");
      print("UPLOAD TIME: ${end.difference(start).inSeconds} DETIK");

      print("FIREBASE URL: $url");

      return url;
    } catch (e) {
      print("UPLOAD ERROR: $e");
      return "";
    }
  }

  /// SIMPAN DATA KAJIAN KE FIREBASE DATABASE
  Future<void> simpanKajian() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final startTotal = DateTime.now();
      print("MULAI SIMPAN KAJIAN");

      /// upload poster
      String posterUrl = await uploadPoster();

      print("UPLOAD SELESAI");
      print("POSTER URL: $posterUrl");

      String id = widget.kajian?.id ?? ref.push().key!;
      print("ID DATA: $id");

      final kajian = Kajian(
        id: id,
        judul: judulController.text,
        pemateri: pemateriController.text,
        deskripsi: deskripsiController.text,
        tanggal: tanggalController.text,
        poster: posterUrl,
      );

      print("DATA MAP: ${kajian.toMap()}");

      final dbStart = DateTime.now();
      print("MULAI SIMPAN DATABASE");

      try {
        await ref
            .child(id)
            .set(kajian.toMap())
            .timeout(const Duration(seconds: 10));

        print("DATA BERHASIL DISIMPAN");
      } catch (e) {
        print("DATABASE ERROR: $e");
      }

      final dbEnd = DateTime.now();

      print("DATABASE TIME: ${dbEnd.difference(dbStart).inMilliseconds} ms");

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.kajian != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Kajian" : "Tambah Kajian")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// POSTER
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
                        : (widget.kajian != null &&
                              widget.kajian!.poster.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(widget.kajian!.poster),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      (imageFile == null &&
                          (widget.kajian == null ||
                              widget.kajian!.poster.isEmpty))
                      ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              /// JUDUL
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Kajian",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Judul wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              /// PEMATERI
              TextFormField(
                controller: pemateriController,
                decoration: const InputDecoration(
                  labelText: "Pemateri",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              /// TANGGAL
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                onTap: pickDate,
                decoration: const InputDecoration(
                  labelText: "Tanggal Kajian",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              const SizedBox(height: 15),

              /// DESKRIPSI
              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTON SIMPAN
              ElevatedButton(
                onPressed: isLoading ? null : simpanKajian,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEdit ? "Update Kajian" : "Simpan Kajian"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
