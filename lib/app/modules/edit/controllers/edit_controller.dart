import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';

class EditController extends GetxController {
  String? basename;
  TextEditingController title = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  Future<DocumentSnapshot<Object?>> getData(String id) async {
    var data =
        await FirebaseFirestore.instance.collection('content').doc(id).get();
    return data;
  }

  Future<void> updateData(String title, String deskripsi, int price,
      String imageUrl, String id) async {
    await FirebaseFirestore.instance.collection('content').doc(id).update({
      'title': title,
      'deskripsi': deskripsi,
      'price': price,
      'imageUrl': imageUrl,
    });
  }

  Future<String?> uploadImage(File image, String? oldImageUrl) async {
    if (image == null) {
      return oldImageUrl;
    }

    Reference ref =
        FirebaseStorage.instance.ref().child('images').child((image.path));
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    if (oldImageUrl != null) {
      await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
    }

    return imageUrl;
  }
}
