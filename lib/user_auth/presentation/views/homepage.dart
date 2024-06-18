import 'package:app/services/firebase_services.dart';
import 'package:app/user_auth/presentation/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseServices firebaseService = FirebaseServices();
  final TextEditingController _noteController = TextEditingController();
  void openBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _noteController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docId == null) {
                        firebaseService.addNote(_noteController.text);
                      } else {
                        firebaseService.updateNote(docId, _noteController.text);
                      }
                      _noteController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ));
              },
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Align(
              alignment: Alignment(-0.2, 0),
              child: Text(
                "Notes",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ListTile(
                        tileColor:
                            //  Theme.of(context).primaryColor
                            Colors.grey[800],
                        title: const Text(
                          "Notes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        tileColor: Colors.grey[800],
                        title: const Text(
                          "Passwords",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text(
                          "Log out",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: openBox,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.grey[900],
          body: StreamBuilder<QuerySnapshot>(
            stream: firebaseService.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List notesList = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = notesList[index];
                      String docId = document.id;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      String noteText = data['note'];

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 16),
                        child: ListTile(
                          minTileHeight: 80,
                          tileColor: Theme.of(context).primaryColor,
                          title: Text(
                            noteText,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () => openBox(docId: docId),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    firebaseService.deleteNode(docId),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Text(
                  "No data",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                );
              }
            },
          )),
    );
  }
}
