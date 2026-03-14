import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:masjid_berhasil/views/admin/news_list_screen.dart';
import 'package:masjid_berhasil/views/admin/kajian_list_screen.dart';
import 'package:masjid_berhasil/views/admin/program_list_screen.dart';
import 'package:masjid_berhasil/views/user/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final DatabaseReference beritaRef = FirebaseDatabase.instance.ref("berita");
  final DatabaseReference programRef = FirebaseDatabase.instance.ref("program");
  final DatabaseReference kajianRef = FirebaseDatabase.instance.ref("kajian");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Masjid At-Taufiq"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              /// MENU ADMIN
              const Text(
                "Menu Admin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _menuCard(
                    context,
                    "Kelola Berita",
                    Icons.article,
                    Color(0xFF2E6F88),
                    const BeritaListScreen(),
                  ),

                  _menuCard(
                    context,
                    "Kelola Program",
                    Icons.mosque,
                    Color(0xFF2E6F88),
                    const ProgramListScreen(),
                  ),

                  _menuCard(
                    context,
                    "Kelola Kajian",
                    Icons.menu_book,
                    Color(0xFF2E6F88),
                    const KajianListScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// MENU GRID
  Widget _menuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
