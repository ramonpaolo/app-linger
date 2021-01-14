//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:linger/src/pages/home/Home.dart';
import 'package:linger/src/pages/home/widgets/CreateProduct.dart';
import 'package:linger/src/pages/user/User.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _page = 0;

  _setScreen(int page) {
    switch (page) {
      case 0:
        return Home();
        break;
      case 1:
        return User();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _setScreen(_page),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _page == 0
          ? Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateProduct()));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 150, 243, 1),
                      borderRadius: BorderRadius.circular(40)),
                  width: size.width * 0.32,
                  height: size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.camera, color: Colors.white),
                      Text(
                        "Criar anúncio",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: (value) {
            setState(() {
              _page = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
          ]),
    );
  }
}
