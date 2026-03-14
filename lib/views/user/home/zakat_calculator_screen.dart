import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masjid_berhasil/theme/app_theme.dart';

class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final uangController = TextEditingController();
  final investasiController = TextEditingController();
  final hutangController = TextEditingController();

  final gajiController = TextEditingController();
  final bonusController = TextEditingController();
  final cicilanController = TextEditingController();

  double hasilZakat = 0;
  double penghasilanBersih = 0;

  final formatter = NumberFormat("#,###", "id_ID");

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  double parse(TextEditingController c) {
    if (c.text.isEmpty) return 0;
    return double.parse(c.text);
  }

  void hitungZakatMaal() {
    double uang = parse(uangController);
    double investasi = parse(investasiController);
    double hutang = parse(hutangController);

    double total = uang + investasi - hutang;

    if (total < 0) total = 0;

    setState(() {
      hasilZakat = total * 0.025;
    });
  }

  void hitungZakatPenghasilan() {
    double gaji = parse(gajiController);
    double bonus = parse(bonusController);
    double cicilan = parse(cicilanController);

    penghasilanBersih = gaji + bonus - cicilan;

    if (penghasilanBersih < 0) penghasilanBersih = 0;

    setState(() {
      hasilZakat = penghasilanBersih * 0.025;
    });
  }

  Widget inputField(
    String title,
    TextEditingController controller, {
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(color: color ?? AppTheme.textPrimary),
            decoration: const InputDecoration(
              prefixText: "Rp ",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget hasilCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ESTIMASI ZAKAT ANDA",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp ${formatter.format(hasilZakat)}",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "2.5%",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget zakatMaal() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.secondary],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Informasi Nisab\nNisab Zakat Maal setara dengan harga 85gr emas.",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        inputField("TABUNGAN & UANG TUNAI", uangController),
        inputField("INVESTASI (EMAS/SAHAM)", investasiController),
        inputField("HUTANG JATUH TEMPO", hutangController),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: hitungZakatMaal,
          child: const Text("Hitung Zakat"),
        ),
        const SizedBox(height: 16),
        hasilCard(),
      ],
    );
  }

  Widget zakatPenghasilan() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.secondary],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Informasi Nisab\nNisab setara harga 522kg beras / bulan.",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        inputField("PENGHASILAN PER BULAN", gajiController),
        inputField("BONUS & PENDAPATAN LAIN", bonusController),
        inputField(
          "HUTANG / CICILAN BULANAN",
          cicilanController,
          color: Colors.red,
        ),
        ElevatedButton(
          onPressed: hitungZakatPenghasilan,
          child: const Text("Hitung Zakat"),
        ),
        const SizedBox(height: 16),
        hasilCard(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kalkulator Zakat",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              child: Text(
                "Zakat Maal",
                style: TextStyle(color: AppTheme.primary),
              ),
            ),
            Tab(
              child: Text(
                "Zakat Penghasilan",
                style: TextStyle(color: AppTheme.primary),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: tabController,
          children: [zakatMaal(), zakatPenghasilan()],
        ),
      ),
    );
  }
}
