import 'package:adv_final_exam/attendence/attendence_service.dart';
import 'package:adv_final_exam/database_helper/helper.dart';
import 'package:adv_final_exam/modal/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TrackerProvider extends ChangeNotifier {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void CloudToLocal() async {
    try {
      final snapshot =
          await TrackerService.trackerService.readAttendenceToFireStore().first;
      final attendence = snapshot.docs.map((doc) {
        final data = doc.data();
        return TrackerModal(
          name: data['name'],
          date: data['data'],
          present: data['present'],
        );
      }).toList();
      for (var tracker in attendence) {
        bool exists =
            await DatabaseHelper.databaseHelper.TrackerExists(tracker.id!);
        if (exists) {
          await DatabaseHelper.databaseHelper.updateAttendence(
              tracker.id!, tracker.name, tracker.date, tracker.present);
        }
      }
    } catch (e) {
      debugPrint("Error syncing date : $e");
    }
  }

  var TrackerList = [];
  List<TrackerModal> attendList = [];
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPresent = TextEditingController();
  String date = '';

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  Future<void> addAttendence(String name, String date, String present) async {
    await DatabaseHelper.databaseHelper.addDataBase(
      name,
      date,
      present,
    );
    toMap(
      TrackerModal(
        name: name,
        date: date,
        present: present,
      ),
    );
  }

  void toMap(TrackerModal trackerModal) {}
}
