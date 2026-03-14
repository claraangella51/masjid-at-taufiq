import 'dart:async';
import 'package:flutter/material.dart';

class PrayerCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const PrayerCard({super.key, required this.data});

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard> {
  DateTime now = DateTime.now();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text("Cempaka Putih", style: TextStyle(color: Colors.white)),
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
