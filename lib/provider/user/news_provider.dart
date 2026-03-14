import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../model/admin/news_model.dart';

class NewsProvider extends ChangeNotifier {
  List<Berita> _newsList = [];

  List<Berita> get newsList => _newsList;

  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://masjid-at-taufiq-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("news");

  NewsProvider() {
    listenNews();
  }

  void listenNews() {
    ref.onValue.listen((event) {
      final snapshot = event.snapshot;

      if (!snapshot.exists) {
        _newsList = [];
        notifyListeners();
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      List<Berita> temp = [];

      data.forEach((key, value) {
        temp.add(Berita.fromMap(key, Map<String, dynamic>.from(value)));
      });

      _newsList = temp;
      notifyListeners();
    });
  }

  void deleteNews(String id) {
    ref.child(id).remove();
  }
}
