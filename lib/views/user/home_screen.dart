import 'package:flutter/material.dart';
import 'package:masjid_berhasil/views/user/info/about_screen.dart';
import 'package:masjid_berhasil/views/user/zakat/zakat_screen.dart';
import 'package:masjid_berhasil/widgets/botnavbar.dart';
import 'home/home_dashboard.dart';
import 'news/berita_screen.dart';
import '../donation_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  final String email;
  const HomeScreen({super.key, required this.fullName, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      HomeDashboard(fullName: widget.fullName, email: widget.email),
      BeritaScreen(),
      DonasiTabScreen(),
      DonationHistoryScreen(),
      AboutScreen(),
    ];
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,

      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: PremiumNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
