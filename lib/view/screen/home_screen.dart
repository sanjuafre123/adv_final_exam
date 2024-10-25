
import 'package:adv_final_exam/modal/modal.dart';
import 'package:adv_final_exam/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'componetes/my_text_field.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<TrackerProvider>(context);
    var providerFalse = Provider.of<TrackerProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.12,
              child: const DrawerHeader(
                child: Text('Settings'),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: () {
                List<TrackerModal> data = providerTrue.TrackerList
                    .map(
                      (e) => TrackerModal.fromMap(e),
                    )
                    .toList();
                for (int i = 0; i < data.length; i++) {
                  providerFalse.addAttendence(data[i].present,data[i].date,data[i].name);
                }
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Backup complete'),
                    content:
                        const Text('All the data successfully stores to cloud'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Backup',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: providerFalse.initDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<TrackerModal> notesModal = providerTrue.TrackerList
              .map(
                (e) => TrackerModal.fromMap(e),
              )
              .toList();

          return ListView.builder(
            itemCount: notesModal.length,
            itemBuilder: (context, index) => ListTile(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notesModal[index].name,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          notesModal[index].date,
                          style: const TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              notesModal[index].present,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              notesModal[index].date,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                providerTrue.txtName.text =
                                    notesModal[index].name;
                                providerTrue.txtPresent.text =
                                    notesModal[index].date;
                                providerTrue.date = notesModal[index].date;
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Update Notes'),
                                    actions: [
                                      MyTextField(
                                        label: 'Name',
                                        controller: providerTrue.txtName,
                                      ),
                                      MyTextField(
                                        label: 'present',
                                        controller: providerTrue.txtPresent,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              leading: Text('${index + 1}'),
              title: Text(notesModal[index].name),
              subtitle: Text(notesModal[index].present),
              trailing: Text(notesModal[index].date),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Notes'),
              actions: [
                MyTextField(
                  label: 'Title',
                  controller: providerTrue.txtName,
                ),
                MyTextField(
                  label: 'Content',
                  controller: providerTrue.txtPresent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        DateTime dateTime = DateTime.now();
                        providerTrue.date =
                            '${dateTime.hour % 12}:${dateTime.minute}';
                        providerFalse.addAttendence(
                          providerTrue.txtPresent.text,
                          providerTrue.txtName.text,
                          providerTrue.date,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
