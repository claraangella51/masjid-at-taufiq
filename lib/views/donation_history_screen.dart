import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Donasi")),

      body: ListView(
        children: const [
          ListTile(
            title: Text("Zakat Maal Rutin"),
            subtitle: Text("12 Okt 2023"),
            trailing: Text("Rp 2.500.000"),
          ),

          ListTile(
            title: Text("Infaq Operasional"),
            subtitle: Text("05 Okt 2023"),
            trailing: Text("Rp 500.000"),
          ),
        ],
      ),
    );
  }
}
