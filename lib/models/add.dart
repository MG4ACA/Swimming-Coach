class AddSchedule {
  String? email;
  String? level;
  String? documentId;

  AddSchedule({this.email, this.documentId, this.level});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "documentId": documentId,
      "level": level,
    };
  }
}
