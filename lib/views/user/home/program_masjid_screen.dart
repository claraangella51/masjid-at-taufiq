import 'package:flutter/material.dart';
import 'package:masjid_berhasil/database/admin/program_database.dart';
import 'package:masjid_berhasil/model/admin/program_model.dart'
    as program_model;

class ProgramMasjidScreen extends StatefulWidget {
  const ProgramMasjidScreen({super.key});

  @override
  State<ProgramMasjidScreen> createState() => _ProgramMasjidScreenState();
}

class _ProgramMasjidScreenState extends State<ProgramMasjidScreen> {
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

    if (text.contains("qiyam") || text.contains("tarawih")) {
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

    if (text.contains("qiyam") || text.contains("tahajud")) {
      return Colors.deepPurple;
    }

    return Colors.blueGrey;
  }

  List<program_model.Program> programList = [];

  @override
  void initState() {
    super.initState();
    loadProgram();
  }

  Future<void> loadProgram() async {
    final data = await ProgramDatabase.instance.getAll();

    setState(() {
      programList = data.cast<program_model.Program>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Program Ramadhan & Rutin",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            /// HEADER BANNER
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff2E6F88),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "RAMADHAN KAREEM",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Jadwal Ibadah & Sosial",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Maksimalkan pahala dengan mengikuti rangkaian program rutin di Masjid At-Taufiq.",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            /// LIST PROGRAM
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: programList.length,
                itemBuilder: (context, index) {
                  final program = programList[index];
                  return programCard(program);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CARD PROGRAM

  Widget programCard(program_model.Program program) {
    final icon = getProgramIcon(program.judul);
    final color = getProgramColor(program.judul);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        program.judul,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Text(
                        program.kategori,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: color),

                    const SizedBox(width: 4),

                    Text(program.waktu, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
