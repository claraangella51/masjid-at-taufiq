import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerService {
  static Future<Map<String, dynamic>> getPrayerTimes(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      "https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=2",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data["data"]["timings"];
    } else {
      throw Exception("Failed to load prayer times");
    }
  }
}
