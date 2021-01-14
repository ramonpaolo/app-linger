import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sigepweb/sigepweb.dart';

class AddProduct {
  //---- Variables
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List linkPhotos = [];

  //---- Functions

  Future addPhoto(List file, String id) async {
    try {
      for (var x = 0; x < file.length; x++) {
        await firebaseStorage
            .ref("photoProduts/" +
                FirebaseAuth.instance.currentUser.uid +
                "/" +
                id +
                "/$x")
            .putFile(File(file[x]));
        linkPhotos.add(await firebaseStorage
            .ref("photoProduts/" +
                FirebaseAuth.instance.currentUser.uid +
                "/" +
                id)
            .child("$x")
            .getDownloadURL());
      }
    } catch (e) {
      print(e);
    }
  }

  Future addProduct(
      String title,
      String subtitle,
      String description,
      String price,
      String cepOrigem,
      String id,
      double latitudeVendedor,
      double longetudeVendedor) async {
    var consultaCEPDestino;

    var sigep = Sigepweb(contrato: SigepContrato.semContrato());

    consultaCEPDestino = await sigep.consultaCEP(cepOrigem);

    print("CEP_ORIGEM: $cepOrigem");
    print(consultaCEPDestino.cidade);

    await firebaseFirestore.collection("products").add({
      "latitude": latitudeVendedor,
      "longetude": longetudeVendedor,
      "views": 0,
      "id_author": FirebaseAuth.instance.currentUser.uid,
      "cidade": consultaCEPDestino.cidade,
      "cep_origem": cepOrigem,
      "image": linkPhotos,
      "price": double.parse(price),
      "describe": description,
      "subtitle": subtitle,
      "title": title,
      "id": id,
    });
  }
}
