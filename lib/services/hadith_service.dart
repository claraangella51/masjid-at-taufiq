import 'dart:math';
import 'package:masjid_berhasil/model/user/hadith_model.dart';

class HadithService {
  static List<Hadith> hadithList = [
    Hadith(
      text: "Sebaik-baik manusia adalah yang paling bermanfaat bagi orang lain",
      narrator: "HR Ahmad & Thabrani",
    ),

    Hadith(
      text: "Sesungguhnya amal itu tergantung niatnya",
      narrator: "HR Bukhari & Muslim",
    ),

    Hadith(
      text:
          "Barang siapa memudahkan kesulitan orang lain Allah akan memudahkannya",
      narrator: "HR Muslim",
    ),
  ];

  static Hadith getRandomHadith() {
    final random = Random();

    return hadithList[random.nextInt(hadithList.length)];
  }
}
