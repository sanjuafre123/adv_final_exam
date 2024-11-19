import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class ShoppingService {
  ShoppingService._();

  static ShoppingService shoppingService = ShoppingService._();
  final _firestore = FirebaseFirestore.instance;

  Future<void> addDataInStore({
    required id,
    required int name,
    required String cate,
    required String qut,
  }) async {
    await _firestore
        .collection("users")
        .doc(AuthServices.userServices.getCurrentUser()!.email)
        .collection("shopping")
        .doc(id.toString())
        .set({
      'name': name,
      'cate': cate,
      'qut': qut,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readDataFromStore() {
    return _firestore
        .collection("users")
        .doc(AuthServices.userServices.getCurrentUser()!.email)
        .collection("shopping")
        .snapshots();
  }
}
