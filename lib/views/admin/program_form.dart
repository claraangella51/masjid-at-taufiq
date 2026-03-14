import 'package:flutter/material.dart';
import 'package:masjid_berhasil/database/admin/program_database.dart';
import 'package:masjid_berhasil/model/admin/program_model.dart';

class FormProgram extends StatefulWidget {
  final Program? program;

  const FormProgram({super.key, this.program});

  @override
  State<FormProgram> createState() => _FormProgramState();
}

class _FormProgramState extends State<FormProgram> {
  final judulController = TextEditingController();
  final waktuController = TextEditingController();

  String kategori = "Harian";

  @override
  void initState() {
    super.initState();

    if (widget.program != null) {
      judulController.text = widget.program!.judul;
      waktuController.text = widget.program!.waktu;
      kategori = widget.program!.kategori;
    }
  }

  Future<void> simpanProgram() async {
    if (judulController.text.trim().isEmpty ||
        waktuController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan waktu program harus diisi")),
      );
      return;
    }

    try {
      final program = Program(
        id: widget.program?.id,
        judul: judulController.text.trim(),
        kategori: kategori,
        waktu: waktuController.text.trim(),
      );

      if (widget.program == null) {
        await ProgramDatabase.instance.insert(program);
      } else {
        await ProgramDatabase.instance.update(program);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan program: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.program == null
              ? "Tambah Program Masjid"
              : "Edit Program Masjid",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [
            /// JUDUL PROGRAM
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: "Judul Program",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// KATEGORI PROGRAM
            DropdownButtonFormField<String>(
              value: kategori,
              decoration: const InputDecoration(
                labelText: "Kategori Program",
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(value: "Harian", child: Text("Harian")),

                DropdownMenuItem(value: "Mingguan", child: Text("Mingguan")),

                DropdownMenuItem(value: "Special", child: Text("Special")),
              ],

              onChanged: (value) {
                setState(() {
                  kategori = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// WAKTU PROGRAM
            TextField(
              controller: waktuController,
              decoration: const InputDecoration(
                labelText: "Waktu Program (Contoh: Ba'da Subuh)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON SIMPAN
            ElevatedButton(
              onPressed: simpanProgram,
              child: const Text("Simpan Program"),
            ),
          ],
        ),
      ),
    );
  }
}
