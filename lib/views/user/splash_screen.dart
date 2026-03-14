import 'dart:async';
import 'package:flutter/material.dart';
import 'package:masjid_berhasil/views/user/home/home_dashboard.dart';
import 'package:masjid_berhasil/views/user/home_screen.dart';
import 'package:masjid_berhasil/views/user/register_screen.dart';
import 'package:masjid_berhasil/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../provider/user/auth_provider.dart';
import 'package:masjid_berhasil/views/user/login_screen.dart';
import 'package:masjid_berhasil/views/admin/admin_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      if (authProvider.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        final user = authProvider.user;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              fullName: user?.displayName ?? "Jamaah",
              email: user?.email ?? "",
            ),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              /// LOGO
              Image.asset("assets/images/logomasjid.png", width: 300),

              const SizedBox(height: 30),

              /// TITLE
              Text(
                "Masjid At-Taufiq",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: AppTheme.primary),
              ),

              const SizedBox(height: 12),

              /// TAGLINE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Menebar Sunnah, Mempererat Ukhuwah",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 40),

              /// VERSION
              const Text(
                "v1.0.0",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
