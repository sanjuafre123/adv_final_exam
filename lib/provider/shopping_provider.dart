import 'package:adv_final_exam/modal/modal.dart';
import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../service/shopping_services.dart';

class ShoppingProvider extends ChangeNotifier {
  List<ShoppingModal> notesList = [];
  var txtName = TextEditingController();
  var txtQut = TextEditingController();
  var txtCate = TextEditingController();
  var txtSearch = TextEditingController();
  String date = '';
  int id = 0;

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  void clearAll() {
    txtName.clear();
    txtCate.clear();
    txtQut.clear();
    date = '';
    notifyListeners();
  }

  Future<void> syncCloudToLocal() async {
    final snapshot =
        await ShoppingService.shoppingService.readDataFromStore().first;
    final cloudExpense = snapshot.docs.map(
      (doc) {
        final data = doc.data();
        return ShoppingModal(
          name: data['name'],
          cate: data['cat'],
          qut: data['qut'],
          done: data['done'],
        );
      },
    ).toList();

    for (var shopping in cloudExpense) {
      bool exists = await DatabaseHelper.databaseHelper
          .expenseExist(shopping.name.length);

      if (exists) {
        await updateNoteInDatabase(
          name: shopping.name,
          cate: shopping.cate,
          qut: shopping.qut.toString(),
          done: shopping.
        );
      } else {
        await insertDatabase(
          name: shopping.name,
          cate: shopping.cate,
          qut: shopping.qut.toString(),
        );
      }
    }
  }

  Future<void> addDataInStore({
    required String name,
    required String qut,
    required String cate,
  }) async {
    await ShoppingService.shoppingService.addDataInStore(
      name: name.length,
      qut: qut,
      cate: cate,
      id: id,
    );
  }

  // Search functionality
  List<ShoppingModal> searchListCategory = [];
  List searchList = [];
  String search = '';

  void getSearch(String value) {
    search = value;
    getCategoryExpense();
    notifyListeners();
  }

  Future<List<Map<String, Object?>>> getCategoryExpense() async {
    return searchList =
        await DatabaseHelper.databaseHelper.getExpenseByCategory(search);
  }

  Future<void> insertDatabase({
    required String name,
    required String qut,
    required String cate,
    required  bool done,
  }) async {
    await DatabaseHelper.databaseHelper.addExpenseToDatabase(
      name,
      cate.length,
      qut.toString(),
      done
    );

    await readDataFromDatabase();
    clearAll();
  }


  Future<void> updateNoteInDatabase({
    required String name,
    required String qut,
    required String cate,
    required bool done
  }) async {
    int quantity = int.tryParse(qut) ?? 0;

    await DatabaseHelper.databaseHelper.updateExpense(
      name,
      quantity,
      cate.toString(),
      qut.toString().isNotEmpty,
    );

    await readDataFromDatabase();
    clearAll();
  }

  Future<List<ShoppingModal>> readDataFromDatabase() async {
    final data = await DatabaseHelper.databaseHelper.readAllExpense();
    notesList = data.map((e) => ShoppingModal.fromMap(e)).toList();
    return notesList;
  }


  Future<void> deleteNoteInDatabase({required int id}) async {
    await DatabaseHelper.databaseHelper.deleteExpense(id);
    readDataFromDatabase();
    notifyListeners();
  }

  ShoppingProvider() {
    initDatabase();
  }
}
