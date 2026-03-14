import 'package:flutter/material.dart';
import 'package:masjid_berhasil/provider/user/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:masjid_berhasil/model/admin/info_kajian_model.dart';
import 'package:masjid_berhasil/views/admin/info_kajian_form.dart';

class KajianListUserScreen extends StatefulWidget {
  const KajianListUserScreen({super.key});

  @override
  State<KajianListUserScreen> createState() => _KajianListUserScreenState();
}

class _KajianListUserScreenState extends State<KajianListUserScreen> {
  @override
  void initState() {
    super.initState();
    loadKajianFromFirebase();
  }

  void loadKajianFromFirebase() {
    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://masjid-at-taufiq-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ).ref("kajian");

    ref.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        final Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(
          data as Map,
        );
        List<Kajian> tempList = [];

        map.forEach((key, value) {
          tempList.add(
            Kajian(
              id: key.toString(),
              judul: value["judul"] ?? "",
              pemateri: value["pemateri"] ?? "",
              tanggal: value["tanggal"] ?? "",
              deskripsi: value["deskripsi"] ?? "",
              poster: value["poster"] ?? "",
            ),
          );
        });

        // Update provider
        Provider.of<EventProvider>(
          context,
          listen: false,
        ).setKajianList(tempList);
      }
    });
  }

  void deleteKajian(String key) {
    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://masjid-at-taufiq-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ).ref("kajian");
    ref.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    final kajianList = Provider.of<EventProvider>(context).kajianList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Timeline Kajian",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3c68a), Color(0xff5d8f92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: kajianList.length,
          itemBuilder: (context, index) {
            final kajian = kajianList[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TIMELINE DOT + LINE
                  Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 260,
                        color: Colors.grey.shade200.withOpacity(0.4),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// CARD CONTENT
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// POSTER
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            child: Stack(
                              children: [
                                (kajian.poster.isNotEmpty &&
                                        Uri.tryParse(
                                              kajian.poster,
                                            )?.hasAbsolutePath ==
                                            true)
                                    ? Image.network(
                                        kajian.poster,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 180,
                                        color: Colors.grey.shade300,
                                      ),

                                Container(
                                  height: 180,
                                  decoration: BoxDecoration(
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

                                Positioned(
                                  bottom: 14,
                                  left: 14,
                                  right: 14,
                                  child: Text(
                                    kajian.judul,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 14,
                                      child: Icon(Icons.person, size: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      kajian.pemateri,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16),
                                    const SizedBox(width: 6),
                                    Text(kajian.tanggal),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                const Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16),
                                    SizedBox(width: 6),
                                    Text("Ruang Utama"),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  kajian.deskripsi,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
