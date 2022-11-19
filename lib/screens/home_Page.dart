import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/color.dart';
import '../common/edit_note.dart';
import '../global/global.dart';
import '../helper/helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController titleController = TextEditingController();
  static TextEditingController contextController = TextEditingController();

  int color_id = Random().nextInt(Style.cardsColor.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.mainColor,
      appBar: AppBar(
        title: Text(
          "Author App",
          style: GoogleFonts.roboto(
              color: Color(0xff607d8b),
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        centerTitle: true,
        backgroundColor: Style.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your recent Authors",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    CloudFirestoreHelper.cloudFirestoreHelper.selectRecord(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    QuerySnapshot? data = snapshot.data;
                    List<QueryDocumentSnapshot> list = data!.docs;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xff607d8b),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Image.network("${list[i]['image']}"),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${list[i]['author_name']}",
                                    style: Style.mainTitle,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "${list[i]['author_book']}",
                                    style: Style.mainContext,
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await CloudFirestoreHelper
                                              .cloudFirestoreHelper
                                              .deleteRecord(id: list[i].id);
                                        },
                                        icon:
                                            Icon(Icons.delete_outline_rounded),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          //await CloudFirestoreHelper.cloudFirestoreHelper.updateRecord(id: list[i].id, updateData: updateData())
                                          updateData(id: list[i].id);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: list.length,
                    );
                  }
                  return Text(
                    "There is no Notes",
                    style: GoogleFonts.nunito(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Style.accentColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditAuthor()));
        },
        label: Text("Add Author"),
        icon: Icon(Icons.add),
      ),
    );
  }

  updateData({required String id}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text("Update"),
                ),
                TextFormField(
                  controller: titleController,
                  onSaved: (val) {
                    Global.author = val!;
                  },
                  validator: (val) {
                    (val!.isEmpty) ? 'Enter your author name first...' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Author Name",
                    label: Text("Enter Your Author Name"),
                  ),
                ),
                TextFormField(
                  controller: contextController,
                  onSaved: (val) {
                    Global.book = val!;
                  },
                  validator: (val) {
                    (val!.isEmpty) ? 'Enter your author book Name first' : null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Author Book Name",
                    label: Text("Enter Your Author Book Name"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          Map<String, dynamic> update = {
                            'note_title': Global.author,
                            'note_context': Global.book,
                          };

                          CloudFirestoreHelper.cloudFirestoreHelper
                              .updateRecord(id: id, updateData: update);

                          titleController.clear();
                          contextController.clear();

                          setState(() {
                            Global.author = "";
                            Global.book = "";
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Update"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        titleController.clear();
                        contextController.clear();

                        setState(() {
                          Global.author = "";
                          Global.book = "";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddNote extends StatefulWidget {
  AddNote(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: Style.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: Style.cardsColor[color_id],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc['author_name'],
              style: Style.mainTitle,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.doc['author_book'],
              style: Style.mainContext,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
