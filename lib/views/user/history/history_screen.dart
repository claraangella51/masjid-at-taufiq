import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Donasi")),

      body: ListView(
        children: const [
          ListTile(
            title: Text("Zakat Maal"),
            subtitle: Text("Rp 500.000"),
            trailing: Text("Success"),
          ),

          ListTile(
            title: Text("Infak"),
            subtitle: Text("Rp 100.000"),
            trailing: Text("Success"),
          ),
        ],
      ),
    );
  }
}
