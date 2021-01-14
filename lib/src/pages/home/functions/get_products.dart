//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class GetProduct {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future getProducts() async {
    /*try {
    print("-------------------------------------------");
      print("Estado: " + city[0].adminArea);
      print("Cordenada: ${city[0].coordinates}");
      print("Cidade: " + city[0].subAdminArea);
    } catch (e) {
      print(e);
    print("-------------------------------------------");
    }*/

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/data.json");
    Map dataUser = await jsonDecode(file.readAsStringSync());
    print(await dataUser["cidade"]);
    return await firebaseFirestore
        .collection("products")
        .where("cidade", isEqualTo: await dataUser["cidade"])
        .get();
  }

  Future getProduct(String idProduct) async {
    return await firebaseFirestore.collection("products").doc(idProduct).get();
  }
}
