import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/habit_provider.dart';
import '../../service/auth.dart';
import '../../service/habit_services.dart';

TextEditingController txtName = TextEditingController();
TextEditingController txtTargetDays = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    HabitProvider habitProviderTrue =
        Provider.of<HabitProvider>(context, listen: true);
    HabitProvider habitProviderFalse =
        Provider.of<HabitProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        actions: [
          TextButton(
              onPressed: () async {
                await habitProviderFalse.syncDataCloudToDatabase();
              },
              child: const Text(
                "Save to local",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
            onPressed: () async {
              await CloudFireStoreService.cloudFireStoreService
                  .insertDataIntoFireStore(habitProviderTrue.data);
            },
            child: const Text(
              "Backup",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: habitProviderTrue.data.length,
                itemBuilder: (context, index) {
                  final data = habitProviderTrue.data[index];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(data.habit),
                          subtitle: Text(data.target),
                          leading: Text(data.id.toString()),
                          trailing: Text(data.progress),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            txtName.text = data.habit;
                            txtTargetDays.text = data.target;
                            habitProviderFalse.setProgress("Complete");
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Add Note"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: txtName),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(controller: txtTargetDays),
                                      Consumer<HabitProvider>(
                                        builder: (BuildContext context,
                                                HabitProvider provider,
                                                Widget? child) =>
                                            Column(
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Radio(
                                                    value: "Complete",
                                                    groupValue:
                                                        provider.groupValue,
                                                    onChanged: (value) {
                                                      habitProviderFalse
                                                          .setProgress(value!);
                                                    }),
                                                const Text(
                                                  'Complete',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Radio(
                                                    value: "NotComplete",
                                                    groupValue:
                                                        provider.groupValue,
                                                    onChanged: (value) {
                                                      habitProviderFalse
                                                          .setProgress(value!);
                                                    }),
                                                const Text(
                                                  'NotComplete',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () async {
                                          if (txtTargetDays.text != "" &&
                                              txtName.text != "") {
                                            await habitProviderFalse.updateData(
                                                data.id,
                                                txtName.text,
                                                txtTargetDays.text,
                                                habitProviderTrue.groupValue);
                                            Navigator.pop(context);
                                          } else {
                                            // print("All Field Must Be Required");
                                          }
                                        },
                                        child: const Text("Ok")),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                        onPressed: () => habitProviderFalse.deleteData(data.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
        onPressed: () {
          clearController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Habit"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: txtName,
                      decoration: const InputDecoration(
                          labelText: "Habits",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txtTargetDays,
                      decoration: const InputDecoration(
                          labelText: "Days",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                    ),
                    Consumer<HabitProvider>(
                      builder: (BuildContext context, HabitProvider provider,
                              Widget? child) =>
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                  value: "Complete",
                                  groupValue: provider.groupValue,
                                  onChanged: (value) {
                                    habitProviderFalse.setProgress(value!);
                                  }),
                              const Text("Complete"),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                  value: "NotComplete",
                                  groupValue: provider.groupValue,
                                  onChanged: (value) {
                                    habitProviderFalse.setProgress(value!);
                                  }),
                              const Text("NotComplete"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        habitProviderTrue.id =
                            habitProviderTrue.data.length + 1;
                        if (txtTargetDays.text != "" && txtName.text != "") {
                          await habitProviderFalse.insertData(
                              habitProviderTrue.id,
                              txtName.text,
                              txtTargetDays.text,
                              habitProviderTrue.groupValue);
                          Navigator.pop(context);
                        } else {
                          // print("All Field Must Be Required");
                        }
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

void clearController() {
  txtName.clear();
  txtTargetDays.clear();
}
