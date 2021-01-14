import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linger/src/auth/Login.dart';
import 'package:path_provider/path_provider.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              width: size.width,
              height: size.height * 0.23,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(33, 150, 243, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: Column(
                children: [
                  Divider(
                    color: Colors.blue,
                    height: size.height * 0.05,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.network(
                        FirebaseAuth.instance.currentUser.photoURL != null
                            ? FirebaseAuth.instance.currentUser.photoURL
                            : "",
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        height: size.height * 0.166,
                        width: size.width * 0.35,
                      )),
                ],
              )),
          Divider(color: Colors.white),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: FirebaseAuth.instance.currentUser.displayName,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Atualize seu nome",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                ),
                Divider(color: Colors.white),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  initialValue: FirebaseAuth.instance.currentUser.email,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Atualize seu Email",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                ),
                Divider(color: Colors.white),
                Text("Atualize sua foto de perfil: "),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera, color: Colors.blue),
                      onPressed: () async {
                        var file;
                        var photo;
                        try {
                          file = await ImagePicker.platform
                              .pickImage(source: ImageSource.camera);
                          print(file.path);
                          var firebaseStorage = FirebaseStorage.instance;
                          await firebaseStorage
                              .ref("photoUsers/" +
                                  FirebaseAuth.instance.currentUser.uid)
                              .putFile(File(file.path));
                          photo = await firebaseStorage
                              .ref("photoUsers/")
                              .child("${FirebaseAuth.instance.currentUser.uid}")
                              .getDownloadURL();
                          await FirebaseAuth.instance.currentUser
                              .updateProfile(photoURL: photo);
                        } catch (e) {
                          print(e);
                        }
                      },
                      tooltip: "Adicionar foto",
                    ),
                    IconButton(
                      icon: Icon(Icons.attachment, color: Colors.blue),
                      onPressed: () async {
                        var file;
                        var photo;
                        try {
                          file = await ImagePicker.platform
                              .pickImage(source: ImageSource.gallery);
                          print(file.path);
                          var firebaseStorage = FirebaseStorage.instance;
                          await firebaseStorage
                              .ref("photoUsers/" +
                                  FirebaseAuth.instance.currentUser.uid)
                              .putFile(File(file.path));
                          photo = await firebaseStorage
                              .ref("photoUsers/")
                              .child("${FirebaseAuth.instance.currentUser.uid}")
                              .getDownloadURL();
                          await FirebaseAuth.instance.currentUser
                              .updateProfile(photoURL: photo);
                        } catch (e) {
                          print(e);
                        }
                      },
                      tooltip: "Adicionar foto",
                    ),
                  ],
                ),
                Divider(color: Colors.white),
                RaisedButton.icon(
                    color: Colors.white,
                    elevation: 0.0,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final file = File("${directory.path}/data.json");
                      file.delete();
                      await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (route) => false);
                    },
                    icon: Icon(Icons.exit_to_app, color: Colors.blue),
                    label: Text("Sair da conta")),
                RaisedButton.icon(
                    color: Colors.white,
                    elevation: 0.0,
                    onPressed: () async {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final file = File("${directory.path}/data.json");
                      file.delete();
                      await FirebaseAuth.instance.currentUser.delete();
                      await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (route) => false);
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                    label: Text("Deletar conta"))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
