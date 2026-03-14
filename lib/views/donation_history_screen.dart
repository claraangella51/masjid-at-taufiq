import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RiwayatDonasiScreen extends StatelessWidget {
  const RiwayatDonasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> riwayatDonasi = [
      {
        "title": "Infak Jumat",
        "date": "7 Maret 2026",
        "amount": 50000,
        "status": "Berhasil",
      },
      {
        "title": "Zakat Fitrah",
        "date": "3 Maret 2026",
        "amount": 45000,
        "status": "Berhasil",
      },
      {
        "title": "Donasi Anak Yatim",
        "date": "28 Februari 2026",
        "amount": 100000,
        "status": "Berhasil",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Donasi",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: riwayatDonasi.length,
          itemBuilder: (context, index) {
            final item = riwayatDonasi[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// ICON DONASI
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: AppTheme.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// INFO DONASI
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item["date"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item["status"],
                            style: const TextStyle(
                              color: AppTheme.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// NOMINAL
                  Text(
                    "Rp ${item["amount"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
