import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:masjid_berhasil/model/admin/info_kajian_model.dart';

class EventProvider extends ChangeNotifier {
  List<Kajian> _kajianList = [];

  List<Kajian> get kajianList => _kajianList;

  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://masjid-at-taufiq-default-rtdb.asia-southeast1.firebasedatabase.app/",
  ).ref("kajian");

  EventProvider() {
    listenKajian();
  }

  void listenKajian() {
    ref.onValue.listen((event) {
      final snapshot = event.snapshot;

      if (!snapshot.exists || snapshot.value == null) {
        _kajianList = [];
        notifyListeners();
        return;
      }

      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      List<Kajian> tempList = [];

      data.forEach((key, value) {
        final kajian = Kajian.fromMap(
          key.toString(),
          Map<String, dynamic>.from(value),
        );

        tempList.add(kajian);
      });

      _kajianList = tempList;
      notifyListeners();
    });
  }

  void setKajianList(List<Kajian> list) {
    _kajianList = list;
    notifyListeners();
  }

  void deleteKajian(String id) {
    ref.child(id).remove();
  }
}
