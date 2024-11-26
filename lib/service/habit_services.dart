import 'package:adv_final_exam/view/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modal/modal.dart';
import 'auth.dart';

class CloudFireStoreService {
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService =
      CloudFireStoreService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> insertDataIntoFireStore(List<HabitModel> data) async {
    String? email = AuthService()
        .createAccountWithEmail(txtName.text, txtTargetDays.text)
        .toString();
    for (int i = 0; i < data.length; i++) {
      HabitModel noteModel = data[i];
      await fireStore
          .collection("users")
          .doc(email)
          .collection("habits")
          .doc(data[i].id.toString())
          .set(HabitModel.fromData(noteModel));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllData() {
    String? email = AuthService()
        .createAccountWithEmail(txtName.text, txtTargetDays.text)
        .toString();
    return fireStore
        .collection("users")
        .doc(email)
        .collection("habits")
        .snapshots();
  }
}
