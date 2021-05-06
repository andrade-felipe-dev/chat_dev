import 'dart:io';

import 'package:chat/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _sendMessage({String text, PickedFile imgPick}) async {

    Map<String, dynamic> data = {};


    if(imgPick != null) {
      File imgFile = File(imgPick.path);

      StorageUploadTask task = FirebaseStorage.instance.ref().child("Imagens").child(
        DateTime.now().microsecondsSinceEpoch.toString()
      ).putFile(imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;


      String url = await taskSnapshot.ref.getDownloadURL();
      data["imgUrl"] = url;
    }

    if(text != null) data["text"] = text;


    Firestore.instance.collection("mensagens").add({
      "text" : text
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 0,
      ),
      body: TextComposer(_sendMessage),
    );
  }
}