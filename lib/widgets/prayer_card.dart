import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const PrayerCard({super.key, required this.data});

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard> {
  DateTime now = DateTime.now();
  Timer? timer;

  String locationName = "Memuat lokasi...";
  Map<String, String> prayerTimes = {};

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });

    loadLocationAndTimes();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadLocationAndTimes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lon = position.longitude;

      /// reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        setState(() {
          locationName =
              placemarks.first.subLocality ??
              placemarks.first.locality ??
              "Lokasi";
        });
      }

      /// fetch prayer times from Aladhan API
      final url = Uri.parse(
        "https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=11",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final timings = json["data"]["timings"];

        setState(() {
          prayerTimes = {
            "Subuh": timings["Fajr"],
            "Dzuhur": timings["Dhuhr"],
            "Ashar": timings["Asr"],
            "Maghrib": timings["Maghrib"],
            "Isya": timings["Isha"],
          };
        });
      }
    } catch (e) {
      debugPrint("Lokasi error: $e");
    }
  }

  DateTime parseTime(String time) {
    final parts = time.split(":");
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  Map<String, String> getTimes() {
    if (prayerTimes.isNotEmpty) return prayerTimes;

    return {
      "Subuh": widget.data["Fajr"],
      "Dzuhur": widget.data["Dhuhr"],
      "Ashar": widget.data["Asr"],
      "Maghrib": widget.data["Maghrib"],
      "Isya": widget.data["Isha"],
    };
  }

  Map<String, dynamic> getNextPrayer() {
    final times = getTimes();

    for (var entry in times.entries) {
      final prayerTime = parseTime(entry.value);

      if (now.isBefore(prayerTime)) {
        final diff = prayerTime.difference(now);

        return {
          "name": entry.key,
          "time": entry.value,
          "countdown": "${diff.inMinutes} menit menuju ${entry.key}",
        };
      }
    }

    return {
      "name": "Subuh",
      "time": times["Subuh"],
      "countdown": "Menuju Subuh besok",
    };
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = getNextPrayer();
    final times = getTimes();

    final timeNow =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F6F7E), Color(0xFF2B5F6C)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LOKASI + JAM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    locationName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeNow,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("WIB", style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// TITLE
          const Text(
            "JADWAL SHALAT BERIKUTNYA",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 5),

          /// NEXT PRAYER
          Row(
            children: [
              Text(
                nextPrayer["name"],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC857),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                nextPrayer["time"],
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// COUNTDOWN
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              nextPrayer["countdown"],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          /// LIST SHOLAT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: times.entries.map((e) {
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      e.key,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
