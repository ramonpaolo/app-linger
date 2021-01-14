//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

//---- Screens
import 'package:linger/src/onboarding/Onboarding.dart';
import 'package:linger/src/Nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Linger",
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map boarding = {"email": null};

  Future<File> getData() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  _readData() async {
    try {
      final data = await getData();
      setState(() {
        boarding = jsonDecode(data.readAsStringSync());
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      splashscreenWidget: Splash(),
      gotoWidget: boarding["email"] != null ? Nav() : Onboarding(),
      timerInSeconds: 2,
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          children: [
            ClipPath(
              clipper: CustomTriangleClipperTop(),
              child: Container(
                width: size.width,
                height: size.height * 0.09,
                color: Colors.blue[700],
              ),
            ),
            Divider(
              color: Colors.white,
              height: size.height * 0.08,
            ),
            Image.network(
              "https://cdn.discordapp.com/attachments/769682105948438601/776180627929169980/OSMCV21-removebg-preview.png",
              height: size.height * 0.502,
            ),
            Text("A ferramenta do momento ideial",
                style: TextStyle(fontSize: 22)),
            Divider(
              color: Colors.white,
              height: size.height * 0.206,
            ),
            ClipPath(
              clipper: CustomTriangleClipperBottom(),
              child: Container(
                width: size.width,
                height: size.height * 0.09,
                color: Colors.blue[700],
              ),
            )
          ],
        )));
  }
}

class CustomTriangleClipperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    //---- width para height
    path.lineTo(size.width / 2, 0);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomTriangleClipperBottom extends CustomClipper<Path> {
  Path getClip(Size size) {
    final path = Path();
    //---- width para height
    path.moveTo(size.width, size.height * 0.1);

    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height);

    return path;
  }

  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
