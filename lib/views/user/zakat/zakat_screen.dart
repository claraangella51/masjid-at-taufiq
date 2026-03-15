import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masjid_berhasil/theme/app_theme.dart';
import 'package:masjid_berhasil/views/user/zakat/payment_screen.dart';

class DonasiTabScreen extends StatefulWidget {
  const DonasiTabScreen({super.key});

  @override
  State<DonasiTabScreen> createState() => _DonasiTabScreenState();
}

class _DonasiTabScreenState extends State<DonasiTabScreen> {
  int nominal = 0;
  int kategoriIndex = 0; // 0=zakat,1=infak,2=fidyah
  String zakatType = "Zakat Maal";

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  int jumlahJiwa = 1;
  int hargaBeras = 45000;

  int fidyahHari = 1;
  int fidyahPerHari = 15000;

  final TextEditingController penghasilanController = TextEditingController();
  List<TextEditingController> jiwaControllers = [TextEditingController()];
  final _formKey = GlobalKey<FormState>();

  bool get isZakat => kategoriIndex == 0;
  bool get isInfak => kategoriIndex == 1;
  bool get isFidyah => kategoriIndex == 2;
  bool get isZakatFitrah => kategoriIndex == 0 && zakatType == "Zakat Fitrah";

  String formatRupiah(int value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  void setNominal(int value) {
    setState(() {
      nominal = value;
      nominalController.text = value.toString();
    });
  }

  Widget kategoriCard(int index, String title, IconData icon) {
    bool selected = kategoriIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            kategoriIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? Colors.white
                    : AppTheme.textPrimary.withOpacity(0.6),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nominalButton(int value) {
    bool selected = nominal == value;

    return GestureDetector(
      onTap: () => setNominal(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          NumberFormat.compactCurrency(
            locale: 'id_ID',
            symbol: '',
          ).format(value),
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Zakat & Infak",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PILIH KATEGORI",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  kategoriCard(0, "Zakat", Icons.payments),
                  const SizedBox(width: 10),
                  kategoriCard(1, "Infak", Icons.volunteer_activism),
                  const SizedBox(width: 10),
                  kategoriCard(2, "Fidyah", Icons.restaurant),
                ],
              ),

              const SizedBox(height: 20),

              if (isZakat)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text("Zakat Maal"),
                        selected: zakatType == "Zakat Maal",
                        showCheckmark: false,
                        selectedColor: AppTheme.accent,
                        labelStyle: TextStyle(
                          color: zakatType == "Zakat Maal"
                              ? Colors.white
                              : AppTheme.textPrimary,
                        ),
                        onSelected: (_) {
                          setState(() {
                            zakatType = "Zakat Maal";
                          });
                        },
                      ),

                      const SizedBox(width: 8),

                      ChoiceChip(
                        label: const Text("Zakat Penghasilan"),
                        selected: zakatType == "Zakat Penghasilan",
                        showCheckmark: false,
                        selectedColor: AppTheme.accent,
                        labelStyle: TextStyle(
                          color: zakatType == "Zakat Penghasilan"
                              ? Colors.white
                              : AppTheme.textPrimary,
                        ),
                        onSelected: (_) {
                          setState(() {
                            zakatType = "Zakat Penghasilan";
                          });
                        },
                      ),

                      const SizedBox(width: 8),

                      ChoiceChip(
                        label: const Text("Zakat Fitrah"),
                        selected: zakatType == "Zakat Fitrah",
                        showCheckmark: false,
                        selectedColor: AppTheme.accent,
                        labelStyle: TextStyle(
                          color: zakatType == "Zakat Fitrah"
                              ? Colors.white
                              : AppTheme.textPrimary,
                        ),
                        onSelected: (_) {
                          setState(() {
                            zakatType = "Zakat Fitrah";
                          });
                        },
                      ),
                    ],
                  ),
                ),

              if (isInfak)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Program Kemakmuran Masjid: Donasi infak akan digunakan untuk operasional dan kegiatan masjid.",
                    style: TextStyle(fontSize: 13),
                  ),
                ),

              if (isFidyah)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Fidyah digunakan untuk mengganti kewajiban puasa dengan memberi makan fakir miskin.",
                    style: TextStyle(fontSize: 13),
                  ),
                ),

              // ===== ZAKAT FITRAH =====
              if (isZakatFitrah)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "JUMLAH JIWA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (jumlahJiwa > 1) {
                              setState(() {
                                jumlahJiwa--;
                                if (jiwaControllers.length > jumlahJiwa) {
                                  jiwaControllers.removeLast();
                                }
                                nominal = jumlahJiwa * hargaBeras;
                                nominalController.text = nominal.toString();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          jumlahJiwa.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              jumlahJiwa++;
                              jiwaControllers.add(TextEditingController());
                              nominal = jumlahJiwa * hargaBeras;
                              nominalController.text = nominal.toString();
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        const SizedBox(width: 10),
                        Text("Rp ${hargaBeras.toString()} / jiwa"),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // (jumlah controller disesuaikan pada penambahan/pengurangan jiwa via tombol)
                    Column(
                      children: List.generate(jumlahJiwa, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            controller: jiwaControllers[index],
                            decoration: InputDecoration(
                              labelText: "Nama Jiwa ${index + 1}",
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Nama jiwa wajib diisi";
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),

              // ===== INFAK PROGRAM =====
              if (isInfak)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "PROGRAM KEMAKMURAN MASJID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.65,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Terkumpul Rp 4.500.000 dari target Rp 7.000.000",
                    ),
                  ],
                ),

              // ===== FIDYAH =====
              if (isFidyah)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "JUMLAH HARI PUASA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (fidyahHari > 1) {
                              setState(() {
                                fidyahHari--;
                                nominal = fidyahHari * fidyahPerHari;
                                nominalController.text = nominal.toString();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          fidyahHari.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              fidyahHari++;
                              nominal = fidyahHari * fidyahPerHari;
                              nominalController.text = nominal.toString();
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        const SizedBox(width: 10),
                        Text("Rp ${fidyahPerHari.toString()} / hari"),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              const Text(
                "NOMINAL PEMBAYARAN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  hintText: "Masukkan nominal",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nominal wajib diisi";
                  }
                  if (int.tryParse(value) == null) {
                    return "Nominal harus berupa angka";
                  }
                  return null;
                },

                onChanged: (value) {
                  setState(() {
                    nominal = int.tryParse(value.replaceAll('.', '')) ?? 0;
                  });
                },
              ),

              const SizedBox(height: 12),

              if (kategoriIndex == 1)
                Wrap(
                  spacing: 10,
                  children: [
                    nominalButton(50000),
                    nominalButton(100000),
                    nominalButton(500000),
                    nominalButton(1000000),
                  ],
                ),

              const SizedBox(height: 24),

              if (!isZakatFitrah)
                const Text(
                  "DONASI ATAS NAMA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

              if (!isZakatFitrah) const SizedBox(height: 10),

              if (!isZakatFitrah)
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    hintText: "Nama Lengkap / Hamba Allah",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama donatur wajib diisi";
                    }
                    return null;
                  },
                ),

              SizedBox(height: isZakatFitrah ? 0 : 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    int amount = nominal == 0
                        ? int.tryParse(nominalController.text) ?? 0
                        : nominal;

                    /// nama donatur
                    String donorName = isZakatFitrah
                        ? jiwaControllers
                              .map(
                                (c) => c.text.isEmpty ? "Hamba Allah" : c.text,
                              )
                              .join(", ")
                        : namaController.text;

                    /// jenis donasi
                    String donationType;
                    String detail;

                    if (isZakat) {
                      donationType = zakatType;

                      if (isZakatFitrah) {
                        detail = "$jumlahJiwa Jiwa x Rp $hargaBeras";
                      } else if (zakatType == "Zakat Penghasilan") {
                        detail = "Zakat dari penghasilan";
                      } else {
                        detail = "Zakat Maal";
                      }
                    } else if (isInfak) {
                      donationType = "Infak";
                      detail = "Program Kemakmuran Masjid";
                    } else {
                      donationType = "Fidyah";
                      detail = "$fidyahHari Hari x Rp $fidyahPerHari";
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentConfirmationScreen(
                          amount: amount,
                          donorName: donorName,
                          donationType: donationType,
                          detail: detail,
                          transactionId: '',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Bayar Sekarang",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '"Ambillah zakat dari sebagian harta mereka, dengan zakat itu kamu membersihkan dan mensucikan mereka." (QS. At-Taubah:103)',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
