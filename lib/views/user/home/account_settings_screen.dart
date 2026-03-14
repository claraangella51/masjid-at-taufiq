import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masjid_berhasil/views/user/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;

  const ProfileScreen({super.key, required this.name, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool adzanNotif = true;
  String language = "Bahasa Indonesia";

  /// Widget menu item
  Widget menuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade100,
        child: Icon(icon, color: Colors.blueGrey),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// Logout Firebase
  Future<void> logoutFirebase() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Profil & Pengaturan",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// FOTO PROFIL
            Stack(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xffE6B980),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xff2F6F7E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// NAMA
            Text(
              widget.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            /// EMAIL
            Text(widget.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            /// PENGATURAN AKUN
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PENGATURAN AKUN",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  menuItem(
                    icon: Icons.person_outline,
                    title: "Ubah Profil",
                    subtitle: "Nama, email, dan foto profil",
                    onTap: () {},
                  ),
                  Divider(color: Colors.grey.shade100, height: 1),
                  menuItem(
                    icon: Icons.lock_outline,
                    title: "Ganti Password",
                    subtitle: "Keamanan akun Anda",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            /// PREFERENSI
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PREFERENSI APLIKASI",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  /// NOTIFIKASI ADZAN
                  menuItem(
                    icon: Icons.notifications_none,
                    title: "Notifikasi Adzan",
                    trailing: Switch(
                      value: adzanNotif,
                      activeColor: const Color(0xff2F6F7E),
                      onChanged: (val) {
                        setState(() {
                          adzanNotif = val;
                        });
                      },
                    ),
                  ),
                  Divider(color: Colors.grey.shade100, height: 1),

                  /// BAHASA
                  menuItem(
                    icon: Icons.language,
                    title: "Bahasa",
                    subtitle: language,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.language),
                                title: const Text("Bahasa Indonesia"),
                                onTap: () {
                                  setState(() {
                                    language = "Bahasa Indonesia";
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.language),
                                title: const Text("English"),
                                onTap: () {
                                  setState(() {
                                    language = "English";
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Divider(color: Colors.grey.shade100, height: 1),

                  /// BANTUAN
                  menuItem(icon: Icons.help_outline, title: "Pusat Bantuan"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: logoutFirebase,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Versi 1 (Build 2026)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
