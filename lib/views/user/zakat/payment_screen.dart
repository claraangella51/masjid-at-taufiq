import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masjid_berhasil/services/firestore_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final int amount;
  final String donorName;
  final String donationType;
  final String detail;
  final String transactionId;

  const PaymentConfirmationScreen({
    super.key,
    required this.amount,
    required this.donorName,
    required this.donationType,
    required this.detail,
    required this.transactionId,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  int metode = 0;

  String rupiah(int value) {
    return NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    ).format(value);
  }

  Widget metodeCard(int index, IconData icon, String title, String subtitle) {
    bool selected = metode == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          metode = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentView() {
    if (metode == 0) {
      /// QRIS
      return Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "SCAN QRIS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          QrImageView(data: widget.transactionId, size: 220),
          const SizedBox(height: 10),
          const Text(
            "Gunakan aplikasi bank / e-wallet untuk scan QR",
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }

    if (metode == 1) {
      /// Virtual Account
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: const Column(
          children: [
            Text(
              "TRANSFER VIRTUAL ACCOUNT",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Mandiri VA", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 6),
            SelectableText(
              "9888 1234 5678 9012",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Nomor VA berlaku selama 1 jam",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (metode == 2) {
      /// E‑Wallet
      return Column(
        children: const [
          SizedBox(height: 20),
          Text("Pilih E‑Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Konfirmasi Pembayaran",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOTAL PEMBAYARAN
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "TOTAL PEMBAYARAN",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      rupiah(widget.amount),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "ID Transaksi: #FID-20231024-001",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DETAIL PEMBAYARAN
            const Text(
              "DETAIL PEMBAYARAN",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),

              child: Column(
                children: [
                  rowDetail("Nama Donatur", widget.donorName),

                  const Divider(),

                  rowDetail("Jenis Donasi", widget.donationType),

                  const Divider(),

                  rowDetail("Rincian", widget.detail),

                  const Divider(),

                  rowDetail("SUBTOTAL", rupiah(widget.amount), bold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// METODE PEMBAYARAN
            const Text(
              "METODE PEMBAYARAN",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            metodeCard(0, Icons.qr_code, "QRIS", "Scan QR pembayaran"),

            metodeCard(
              1,
              Icons.account_balance,
              "Virtual Account",
              "Transfer bank",
            ),

            metodeCard(
              2,
              Icons.account_balance_wallet,
              "E-Wallet",
              "GoPay, OVO, Dana",
            ),

            const SizedBox(height: 16),

            /// INFO
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Pembayaran Anda diproses secara aman. Dana donasi akan langsung disalurkan melalui rekening resmi Masjid At-Taufiq Cempaka Putih.",
                style: TextStyle(fontSize: 12),
              ),
            ),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("donations")
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];

                    return ListTile(
                      leading: Icon(
                        data["status"] == "paid"
                            ? Icons.check_circle
                            : Icons.pending,
                        color: data["status"] == "paid"
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text("Rp ${data['amount']}"),
                      subtitle: Text(data["status"]),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget rowDetail(String title, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),

        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
