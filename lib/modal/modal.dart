class HabitModel {
  late int id;
  late String habit, target, progress;

  HabitModel({
    required this.id,
    required this.habit,
    required this.target,
    required this.progress,
  });

  factory HabitModel.fromMap(Map m1) {
    return HabitModel(
        id: m1["id"],
        habit: m1["habit"],
        target: m1["target"],
        progress: m1["progress"]);
  }

  static Map<String, dynamic> fromData(HabitModel habitModel) {
    return {
      "id": habitModel.id,
      "habit": habitModel.habit,
      "target": habitModel.target,
      "progress": habitModel.progress,
    };
  }
}
