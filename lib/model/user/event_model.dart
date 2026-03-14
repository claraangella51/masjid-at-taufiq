class EventModel {
  int? id;
  String title;
  String date;
  String description;

  EventModel({
    this.id,
    required this.title,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "date": date, "description": description};
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map["id"],
      title: map["title"],
      date: map["date"],
      description: map["description"],
    );
  }
}
