import 'package:flutter/material.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Berbagi Zakat")),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          donationCard("Beasiswa Yatim & Dhuafa", "Terkumpul Rp 45.200.000"),

          donationCard("Pemberdayaan Ekonomi Umat", "Terkumpul Rp 12.800.000"),
        ],
      ),
    );
  }

  Widget donationCard(String title, String progress) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(progress),
        trailing: ElevatedButton(onPressed: () {}, child: const Text("Donasi")),
      ),
    );
  }
}
