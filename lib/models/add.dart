class AddSchedule {
  String? email;
  bool? status;
  String? documentId;

  AddSchedule({this.email, this.documentId, this.status});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "documentId": documentId,
      "status": status,
    };
  }
}
