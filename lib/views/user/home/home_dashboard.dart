import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:masjid_berhasil/services/location_service.dart';
import 'package:masjid_berhasil/services/prayer_service.dart';
import 'package:masjid_berhasil/views/user/home/account_settings_screen.dart';
import 'package:masjid_berhasil/views/user/home/info_kajian_screen.dart';
import 'package:masjid_berhasil/views/user/home/program_masjid_screen.dart';
import 'package:masjid_berhasil/views/user/home/zakat_calculator_screen.dart';
import 'package:masjid_berhasil/widgets/hadith_card.dart';
import 'package:masjid_berhasil/widgets/lokasi_masjid.dart';
import 'package:masjid_berhasil/widgets/prayer_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDashboard extends StatefulWidget {
  final String fullName;
  final String email;

  const HomeDashboard({super.key, required this.fullName, required this.email});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  Map<String, dynamic>? prayerTimes;
  String? locationAddress;

  @override
  void initState() {
    super.initState();
    loadPrayerTimes();
  }

  Future<void> loadPrayerTimes() async {
    try {
      Position position = await LocationService.getUserLocation();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        locationAddress =
            "${place.street}, ${place.locality}, ${place.country}";
      });

      final data = await PrayerService.getPrayerTimes(
        position.latitude,
        position.longitude,
      );

      setState(() {
        prayerTimes = data;
      });
    } catch (e) {
      setState(() {
        prayerTimes = {};
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load prayer times: $e')),
      );
    }
  }

  Future<void> openMasjidLocation() async {
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/place/At-Taufiq+Mosque/@-6.1724283,106.8726578,17z/data=!3m1!4b1!4m6!3m5!1s0x2e69f4fc88d63919:0xa3519b1d25462267!8m2!3d-6.1724283!4d106.8752327!16s%2Fg%2F1tkxpmsk?entry=ttu&g_ep=EgoyMDI2MDMxMC4wIKXMDSoASAFQAw%3D%3D",
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  Widget menuItem(IconData icon, String title, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blueGrey),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 12,
            16,
            12,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        name: widget.fullName,
                        email: widget.email,
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 114, 160, 179),
                  radius: 20,
                  child: Icon(Icons.person, color: Color(0xFF1F4F5F)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Assalamualaikum, ${(widget.fullName.trim().isNotEmpty ? widget.fullName.split(' ').first : "Jamaah")}!",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.notifications_none),
            ],
          ),
        ),

        /// BODY
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  prayerTimes == null
                      ? const Center(child: CircularProgressIndicator())
                      : PrayerCard(data: prayerTimes!),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      menuItem(Icons.menu_book, "Info\nKajian", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KajianListUserScreen(),
                          ),
                        );
                      }),
                      menuItem(Icons.mosque, "Program\nMasjid", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProgramMasjidScreen(),
                          ),
                        );
                      }),
                      menuItem(Icons.calculate, "Kalkulator\nZakat", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ZakatCalculatorScreen(),
                          ),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const HadithCard(
                    text:
                        "Dari Abu Hurairah ra., Nabi Muhammad saw. bersabda: 'Barangsiapa beriman kepada Allah dan Hari Akhir, maka hendaklah dia berkata baik atau diam.'",
                    narrator: "Abu Hurairah",
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Lokasi Masjid",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  LokasiMasjid(openMasjidLocation: openMasjidLocation),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
