//---- Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linger/src/pages/home/widgets/Product.dart';

//---- Functions
import 'package:linger/src/pages/home/functions/get_products.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  QuerySnapshot produtos;
  List produtosPesquisados = [];

  TextEditingController _searchController = TextEditingController();

  Future searchProduct(String text) async {
    if (produtosPesquisados.isEmpty) {
      produtos = await GetProduct().getProducts();
    }

    setState(() {
      produtosPesquisados.clear();
    });

    for (var x = 0; x < produtos.docs.length; x++) {
      if (await produtos.docs[x]["title"].contains(text)) {
        print(produtos.docs[x].data());
        setState(() {
          produtosPesquisados.add(produtos.docs[x].data());
        });
      }
    }
    return produtosPesquisados;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
              child: Container(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    Container(
                        width: size.width,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(33, 150, 243, 1),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40))),
                        child: Stack(
                          children: [
                            Positioned(
                              top: size.height * 0.05,
                              left: size.width * 0.35,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: Image.network(
                                    FirebaseAuth.instance.currentUser
                                                .photoURL !=
                                            null
                                        ? FirebaseAuth
                                            .instance.currentUser.photoURL
                                        : "",
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    height: size.height * 0.14,
                                    width: size.width * 0.3,
                                  )),
                            ),
                            Positioned(
                              top: size.height * 0.19,
                              left: size.width * 0.26,
                              child: Text(
                                "Olá, ${FirebaseAuth.instance.currentUser.displayName}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                        top: size.height * 0.22,
                        left: size.width * 0.05,
                        child: Container(
                          width: size.width * 0.9,
                          height: size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) async {
                              if (value.isEmpty) {
                                setState(() {
                                  produtosPesquisados.clear();
                                });
                              } else {
                                await searchProduct(value);
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.clear, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        produtosPesquisados.clear();
                                      });
                                    }),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(33, 150, 243, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Pesquise pelo produto aqui"),
                          ),
                        )),
                    Positioned(
                        top: size.height * 0.28,
                        child: Container(
                            width: size.width,
                            height: size.height * 0.7,
                            child: produtosPesquisados.length == 0
                                ? ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    padding: EdgeInsets.only(
                                        bottom: size.height * 0.11),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      if (index == 2 || index == 3) {
                                        return GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Product(
                                                            dataProduct:
                                                                snapshot.data
                                                                        .docs[
                                                                    index]))),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.white,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              elevation: 0.0,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: ClipRRect(
                                                      //Ou circular(20)
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        "${snapshot.data.docs[index]["image"][0]}",
                                                        filterQuality:
                                                            FilterQuality.low,
                                                        fit: BoxFit.cover,
                                                        height:
                                                            size.height * 0.1,
                                                        width: size.width * 0.2,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                          "${snapshot.data.docs[index]["title"]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[800])),
                                                      subtitle: Text(
                                                          "${snapshot.data.docs[index]["subtitle"]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[400])),
                                                      trailing: Text(
                                                        "R\S${snapshot.data.docs[index]["price"].toString().replaceAll(".", ",")} por Hora",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
                                      } else {
                                        return GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Product(
                                                            dataProduct:
                                                                snapshot.data
                                                                        .docs[
                                                                    index]))),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.white,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              elevation: 0.0,
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    //Ou circular(20)
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                    child: Image.network(
                                                        "${snapshot.data.docs[index]["image"][0]}",
                                                        filterQuality:
                                                            FilterQuality.low,
                                                        fit: BoxFit.cover,
                                                        width: size.width * 0.9,
                                                        height:
                                                            size.height * 0.24),
                                                  ),
                                                  Center(
                                                    child: ListTile(
                                                      title: Text(
                                                          "${snapshot.data.docs[index]["title"]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[800])),
                                                      subtitle: Text(
                                                          "${snapshot.data.docs[index]["subtitle"]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[400])),
                                                      trailing: Text(
                                                        "R\S${snapshot.data.docs[index]["price"].toString().replaceAll(".", ",")} por Hora",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      }
                                    },
                                  )
                                : ListView.builder(
                                    itemCount: produtosPesquisados.length,
                                    padding: EdgeInsets.only(
                                        bottom: size.height * 0.11),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Product(
                                                      dataProduct:
                                                          produtosPesquisados[
                                                              index]))),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.white,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            elevation: 0.0,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: ClipRRect(
                                                    //Ou circular(20)
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                      "${produtosPesquisados[index]["image"][0]}",
                                                      filterQuality:
                                                          FilterQuality.low,
                                                      fit: BoxFit.cover,
                                                      height: size.height * 0.1,
                                                      width: size.width * 0.2,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ListTile(
                                                    title: Text(
                                                        "${produtosPesquisados[index]["title"]}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue[800])),
                                                    subtitle: Text(
                                                        "${produtosPesquisados[index]["subtitle"]}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue[400])),
                                                    trailing: Text(
                                                      "R\S${produtosPesquisados[index]["price"].toString().replaceAll(".", ",")} por Hora",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    })))
                  ],
                ),
              ),
              onRefresh: GetProduct().getProducts);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.5, left: size.width * 0.45),
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding:
                EdgeInsets.only(top: size.height * 0.5, left: size.width * 0.5),
            child: Text("Erro"),
          );
        }
      },
      future: GetProduct().getProducts(),
    ));
  }
}
