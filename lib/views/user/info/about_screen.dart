import 'package:flutter/material.dart';
import 'package:masjid_berhasil/widgets/lokasi_masjid.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> openMap() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/place/At-Taufiq+Mosque/@-6.1724283,106.8726578,17z/data=!3m1!4b1!4m6!3m5!1s0x2e69f4fc88d63919:0xa3519b1d25462267!8m2!3d-6.1724283!4d106.8752327!16s%2Fg%2F1tkxpmsk?entry=ttu&g_ep=EgoyMDI2MDMxMC4wIKXMDSoASAFQAw%3D%3D",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openMasjidLocation() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/place/At-Taufiq+Mosque/@-6.1724283,106.8726578,17z/data=!3m1!4b1!4m6!3m5!1s0x2e69f4fc88d63919:0xa3519b1d25462267!8m2!3d-6.1724283!4d106.8752327!16s%2Fg%2F1tkxpmsk?entry=ttu&g_ep=EgoyMDI2MDMxMC4wIKXMDSoASAFQAw%3D%3D",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openExternal(String link) async {
    final Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 18, color: Colors.blueGrey),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget cardBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER IMAGE
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    child: Image.asset(
                      "assets/images/masjid.png",
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  const Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Masjid At-Taufiq",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Cempaka Putih, Jakarta Pusat",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SEJARAH
                    sectionTitle(Icons.history, "Sejarah Singkat"),

                    cardBox(
                      const Text(
                        "Masjid At-Taufiq didirikan pada tahun 1995 di tengah kawasan "
                        "Cempaka Putih sebagai pusat kegiatan ibadah dan dakwah "
                        "masyarakat. Dimulai dari musholla kecil, berkat gotong "
                        "royong jamaah, kini berkembang menjadi pusat peradaban "
                        "Islam yang aktif di wilayah Jakarta Pusat.",
                        style: TextStyle(height: 1.6),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// VISI MISI
                    sectionTitle(Icons.flag, "Visi & Misi"),

                    cardBox(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "VISI",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Menjadi pusat ibadah dan pemberdayaan umat yang modern, amanah, dan membawa manfaat bagi masyarakat.",
                            style: TextStyle(height: 1.5),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            "MISI",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: const [
                              Icon(Icons.check_circle_outline, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Menyelenggarakan peribadatan yang nyaman dan khusyuk sesuai sunnah.",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: const [
                              Icon(Icons.check_circle_outline, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Mengembangkan pendidikan Islam dan dakwah yang inklusif.",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: const [
                              Icon(Icons.check_circle_outline, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Mengelola zakat, infaq, dan sedekah secara transparan.",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// LOKASI MASJID
                    sectionTitle(Icons.location_city, "Lokasi Masjid"),
                    const SizedBox(height: 20),

                    LokasiMasjid(openMasjidLocation: openMasjidLocation),

                    const SizedBox(height: 20),

                    /// SOSIAL MEDIA
                    sectionTitle(Icons.chat, "Media Sosial"),

                    const SizedBox(height: 12),

                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3.5,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        InkWell(
                          onTap: () => _openExternal(
                            'https://www.youtube.com/@kajiansunnahmasjidattaufiq775',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.play_circle, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  "YouTube",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () => _openExternal(
                            'https://www.instagram.com/masjidattaufiqcempakaputih/',
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.camera_alt, color: Colors.pink),
                                SizedBox(width: 8),
                                Text(
                                  "Instagram",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
