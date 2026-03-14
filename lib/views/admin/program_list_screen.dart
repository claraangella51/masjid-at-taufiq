import 'package:flutter/material.dart';
import 'package:masjid_berhasil/database/admin/program_database.dart';
import 'package:masjid_berhasil/model/admin/program_model.dart';
import 'package:masjid_berhasil/views/admin/program_form.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  List<Program> programList = [];

  /// LOAD DATA
  void loadProgram() async {
    final data = await ProgramDatabase.instance.getAll();

    setState(() {
      programList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProgram();
  }

  /// DELETE
  Future<void> deleteProgram(int id) async {
    await ProgramDatabase.instance.delete(id);
    loadProgram();
  }

  /// ICON & COLOR
  IconData getProgramIcon(String judul) {
    final text = judul.toLowerCase();

    if (text.contains("quran")) {
      return Icons.menu_book;
    }

    if (text.contains("buka") || text.contains("makan")) {
      return Icons.restaurant;
    }

    if (text.contains("kultum") || text.contains("kajian")) {
      return Icons.mic;
    }

    if (text.contains("nuzul")) {
      return Icons.star;
    }

    if (text.contains("qiyam") || text.contains("tahajud")) {
      return Icons.nightlight_round;
    }

    return Icons.mosque;
  }

  Color getProgramColor(String judul) {
    final text = judul.toLowerCase();

    if (text.contains("quran")) {
      return Colors.blue;
    }

    if (text.contains("buka") || text.contains("makan")) {
      return Colors.orange;
    }

    if (text.contains("kultum") || text.contains("kajian")) {
      return Colors.green;
    }

    if (text.contains("nuzul")) {
      return Colors.amber;
    }

    if (text.contains("qiyam") || text.contains("tarawih")) {
      return Colors.deepPurple;
    }

    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Program Masjid")),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: programList.length,
          itemBuilder: (context, index) {
            final program = programList[index];

            return Card(
              margin: const EdgeInsets.all(12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                /// ICON PROGRAM
                leading: CircleAvatar(
                  backgroundColor: getProgramColor(
                    program.judul,
                  ).withOpacity(0.15),
                  child: Icon(
                    getProgramIcon(program.judul),
                    color: getProgramColor(program.judul),
                  ),
                ),

                /// JUDUL
                title: Text(
                  program.judul,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                /// KATEGORI + WAKTU
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kategori: ${program.kategori}"),
                    Text("Waktu: ${program.waktu}"),
                  ],
                ),

                /// BUTTON
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// EDIT
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FormProgram(program: program),
                          ),
                        );

                        if (result == true) {
                          loadProgram();
                        }
                      },
                    ),

                    /// DELETE
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteProgram(program.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      /// TAMBAH PROGRAM
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormProgram()),
          );

          if (result == true) {
            loadProgram();
          }
        },
      ),
    );
  }
}
