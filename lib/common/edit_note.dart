import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:author_app/helper/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'color.dart';

class EditAuthor extends StatefulWidget {
  const EditAuthor({Key? key}) : super(key: key);

  @override
  State<EditAuthor> createState() => _EditAuthorState();
}

class _EditAuthorState extends State<EditAuthor> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contextController = TextEditingController();
  int color_id = Random().nextInt(Style.cardsColor.length);
  
  String imageUrl = '';

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff607d8b),
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
                labelText: "Enter Note Title",
                labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 3,
                  ),
                ),
              ),
              style: Style.mainTitle,
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: contextController,
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Author Book',
                labelText: "Enter Note Title",
                labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 3,
                  ),
                ),
              ),
              style: Style.mainContext,
            ),
            // ImageButton(),
            SizedBox(
              height: 15,
            ),
         

            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  print("**************************");
                  print("**************************");
                  print('${file?.path}');
                  print("**************************");
                  print("**************************");

                  if (file == null) return;
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');
                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);

                  try {
                    await referenceImageToUpload.putFile(File(file!.path));
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {}
                },
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Pick from Camera"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Style.accentColor,
        onPressed: () {
          FirebaseFirestore.instance.collection("author").add({
            "author_name": titleController.text,
            "author_book": contextController.text,
            "color_id": color_id,
            "image": imageUrl,
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
