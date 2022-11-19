import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class EditAuthor extends StatefulWidget {
  const EditAuthor({Key? key}) : super(key: key);

  @override
  State<EditAuthor> createState() => _EditAuthorState();
}

class _EditAuthorState extends State<EditAuthor> {
  int color_id = Random().nextInt(Style.cardsColor.length);

  TextEditingController titleController = TextEditingController();
  TextEditingController contextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: Style.cardsColor[color_id],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Add a new Author Details",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Author Name',
              ),
              style: Style.mainTitle,
            ),
            TextField(
              controller: contextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Author Book',
              ),
              style: Style.mainContext,
            ),
          ],
        ),
      ),
      /**/
      floatingActionButton: FloatingActionButton(
        backgroundColor: Style.accentColor,
        onPressed: () {
          FirebaseFirestore.instance.collection("author").add({
            "author_name": titleController.text,
            "author_book": contextController.text,
            "color_id": color_id,
          }).then((value) {
            print(value.id);
            Navigator.of(context).pop();
          }).catchError((error) => print("Failed to add new $error"));
        },
        child: Icon(Icons.save_rounded),
      ),
    );
  }
}
