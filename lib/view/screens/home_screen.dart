import 'package:adv_final_exam/modal/expense_modal.dart';
import 'package:adv_final_exam/modal/modal.dart';

import 'package:adv_final_exam/view/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/shopping_provider.dart';
import '../../service/auth.dart';
import 'component/my_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<ShoppingProvider>(context);
    var providerFalse = Provider.of<ShoppingProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () async {
              await providerFalse.syncCloudToLocal();
            },
            child: const Text(
              'Save to local',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              List<ShoppingModal> shop;
              shop = providerTrue.notesList
                  .map(
                    (e) => ShoppingModal.fromMap(e.toMap()),
                  )
                  .toList();
              for (int i = 0; i < providerTrue.notesList.length; i++) {
                providerFalse.addDataInStore(
                  name: shop[i].name,
                  cate: shop[i].cate,
                  qut: shop[i].qut.toString(),
                );
              }
            },
            child: const Text(
              'Backup',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await AuthServices.userServices.getCurrentUser();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: MyTextField(
          //     onChanged: (value) {},
          //     controller: providerTrue.txtSearch,
          //     label: 'Search',
          //   ),
          // ),
          GestureDetector(
            // onTap: () {
            //   Navigator.of(context).push(
            //       // MaterialPageRoute(
            //       //   builder: (context) => const SearchScreen(),
            //       // ),
            //       );
            // },
            child: Container(
              alignment: Alignment.centerLeft,
              height: height * 0.06,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Search'),
            ),
          ),
          FutureBuilder(
            future: providerFalse.readDataFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ShoppingModal> notesModal = [];

                notesModal = providerTrue.notesList
                    .map(
                      (e) => ShoppingModal.fromMap(e.toMap()),
                    )
                    .toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: notesModal.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        providerTrue.txtName.text = notesModal[index].name;
                        providerTrue.txtQut.text = notesModal[index].qut.toString();
                        providerTrue.txtCate.text = notesModal[index].cate;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Update Expense'),
                            actions: [
                              MyTextField(
                                controller: providerTrue.txtName,
                                label: 'name',
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              MyTextField(
                                controller: providerTrue.txtQut,
                                label: 'qut',
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              MyTextField(
                                controller: providerTrue.txtCate,
                                label: 'cate',
                              ),
                              SizedBox(
                                height: height * 0.01,
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
                                      providerTrue.date =
                                          '${DateTime.now().hour}:${DateTime.now().minute}';
                                      providerFalse.updateNoteInDatabase(
                                        name: notesModal[index].toString(),
                                        qut: providerTrue.txtCate.text,
                                        cate: providerTrue.txtCate.text,
                                        done: providerTrue.txtQut.text.isNotEmpty,
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
                      leading: Text(notesModal[index].name.toString()),
                      title: Text(notesModal[index].qut.toString()),
                      subtitle: Text(notesModal[index].cate),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(notesModal[index].cate),
                          const VerticalDivider(),
                          Text(notesModal[index].qut.toString()),
                          const VerticalDivider(),
                          IconButton(
                            onPressed: () async {
                              await providerFalse.deleteNoteInDatabase(
                                  id: notesModal[index].name.length);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Shopping'),
              actions: [
                MyTextField(
                  controller: providerTrue.txtName,
                  label: 'Title',
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                MyTextField(
                  controller: providerTrue.txtCate,
                  label: 'Category',
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                MyTextField(
                  controller: providerTrue.txtQut,
                  label: 'qut',
                ),
                SizedBox(
                  height: height * 0.01,
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
                        providerTrue.id = providerTrue.notesList.length + 1;
                        providerTrue.date =
                            '${DateTime.now().hour}:${DateTime.now().minute}';
                        providerFalse.insertDatabase(
                            name: providerTrue.txtName.text,
                            qut: providerTrue.txtQut.text,
                            done: providerTrue.txtQut.text.isNotEmpty,
                            cate: providerTrue.txtCate.text);
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
