import 'package:cloud_firestore/cloud_firestore.dart';

class TrackerService {
  TrackerService._();

  static TrackerService trackerService = TrackerService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAttendenceToFireStore(
      int id, String name, String date, String present) async {
    await _firestore.collection("attendence").doc(id.toString()).set({
      'id': id,
      'name': name,
      'date': date,
      'present': present,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAttendenceToFireStore() {
    return _firestore.collection("attendence").snapshots();
  }
}
