import 'package:flutter/widgets.dart';

import '../helper/database_helper.dart';
import '../modal/modal.dart';
import '../service/habit_services.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> data = [], filteredData = [];
  int id = 1;
  String groupValue = "Complete";
  double per = 0.0;


  void setProgress(String value) {
    groupValue = value;
    notifyListeners();
  }

  HabitProvider() {
    DataBaseService.dataBaseService.initDb();
    getAllHabit();
  }

  Future<void> getAllHabit() async {
    List tempData = await DataBaseService.dataBaseService.getAllData();
    data = tempData.map((e) => HabitModel.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> insertData(
      int id, String habit, String target, String progress) async {
    await DataBaseService.dataBaseService
        .insertData(id, habit, target, progress);
    getAllHabit();
  }

  Future<void> updateData(
      int id, String habit, String target, String progress) async {
    await DataBaseService.dataBaseService
        .updateData(id, habit, target, progress);
    getAllHabit();
  }

  Future<void> deleteData(int id) async {
    await DataBaseService.dataBaseService.deleteData(id);
    getAllHabit();
  }

  Future<void> syncDataCloudToDatabase() async {
    final snapShot =
        await CloudFireStoreService.cloudFireStoreService.getAllData().first;
    final data = snapShot.docs.map((e) {
      HabitModel habitModel = HabitModel.fromMap(e.data());
      return HabitModel(
          id: int.parse(e.id),
          habit: habitModel.habit,
          target: habitModel.target,
          progress: habitModel.progress);
    }).toList();

    for (var habit in data) {
      bool exist = await DataBaseService.dataBaseService.isExist(habit.id);
      if (exist) {
        await DataBaseService.dataBaseService
            .updateData(habit.id, habit.habit, habit.target, habit.progress);
      } else {
        await DataBaseService.dataBaseService
            .insertData(habit.id, habit.habit, habit.target, habit.progress);
      }
      await getAllHabit();
    }
  }
}