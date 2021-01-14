//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

//---- Screens
import 'package:linger/src/auth/Login.dart';

//---- Widgets
import 'package:linger/src/onboarding/widgets/subPage.dart';
import 'package:location/location.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _page = 0;
  final location = Location.instance;

  Future hasPermisao() async {
    for (var i = 0; i < 1000; i++) {
      if (await location.hasPermission() == PermissionStatus.denied ||
          await location.hasPermission() == PermissionStatus.deniedForever) {
        await Location.instance.requestPermission();
      } else {
        i = 999;
        continue;
      }
    }
  }

  @override
  void initState() {
    hasPermisao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(top: size.height * 0.15),
                width: size.width,
                height: size.height * 0.8,
                child: CarouselSlider(
                  items: [
                    subPage(
                        "https://cdn.discordapp.com/attachments/769682105948438601/776180627929169980/OSMCV21-removebg-preview.png",
                        "Nosso app é feito com a ideia de você poder aproveitar o tempo em que você não utiliza tal ferramenta para poder alugá-lá pelo tempo de uso para uma pessoa perto.",
                        size),
                    subPage(
                        "https://cdn.discordapp.com/attachments/769682105948438601/776180627929169980/OSMCV21-removebg-preview.png",
                        "Com esse App você tem todo o networkin e potenciais clientes e vendedores na palma de sua mãe de um jeito muito fácil",
                        size),
                    subPage(
                        "https://cdn.discordapp.com/attachments/769682105948438601/776180627929169980/OSMCV21-removebg-preview.png",
                        "Para aproveitar tudo que esse app oferece, crie uma conta ou logue com uma conta já existe utlizando o Google ou o E-mail : )",
                        size),
                  ],
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: size.height * 0.65,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _page = index;
                        });
                        print(_page);
                      },
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                      pauseAutoPlayOnTouch: true),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: size.width * 0.1,
                    height: size.height * 0.018,
                    child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  _page == 0 ? Colors.white : Colors.blue[200],
                              borderRadius: BorderRadius.circular(40)),
                          width: size.width * 0.06,
                        ))),
                Container(
                    width: size.width * 0.1,
                    height: size.height * 0.018,
                    child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  _page == 1 ? Colors.white : Colors.blue[200],
                              borderRadius: BorderRadius.circular(40)),
                          width: size.width * 0.06,
                        ))),
                Container(
                    width: size.width * 0.1,
                    height: size.height * 0.018,
                    child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  _page == 2 ? Colors.white : Colors.blue[200],
                              borderRadius: BorderRadius.circular(40)),
                          width: size.width * 0.06,
                        ))),
              ],
            ),
            Divider(height: size.height * 0.08, color: Colors.blue),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    width: size.width * 0.5,
                    height: size.height * 0.06,
                    child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              (route) => false);
                        },
                        child: Text("Login/Cadastro")))),
          ],
        )));
  }
}
