//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:linger/src/pages/home/functions/calc_frete.dart';
import 'package:share/share.dart';

class Product extends StatefulWidget {
  Product({Key key, this.dataProduct}) : super(key: key);
  final dataProduct;
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int _image = 0;

  double destino = 0.0;

  TextEditingController _cepDestinoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              width: size.width,
              height: size.height * 0.5,
              child: CarouselSlider.builder(
                  itemCount: widget.dataProduct["image"].length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.dataProduct["image"][index],
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _image = index;
                        });
                      },
                      enableInfiniteScroll: false,
                      initialPage: 0)),
            ),
            //---- Colocado dps de image pois a image anula o button
            Positioned(
              top: size.height * 0.03,
              left: size.width * 0.01,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                    size: 38,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),

            //------------ end 3 icons
            Positioned(
                top: size.height * 0.1,
                left: size.width * 0.2,
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                      "${_image + 1}/${widget.dataProduct["image"].length}"),
                )),
            Positioned(
                top: size.height * 0.4,
                left: size.width * 0.15,
                child: Icon(Icons.star, color: Colors.blue)),
            Positioned(
                top: size.height * 0.4,
                left: size.width * 0.1,
                child: Icon(Icons.star, color: Colors.blue)),
            Positioned(
                top: size.height * 0.4,
                left: size.width * 0.20,
                child: Icon(Icons.star, color: Colors.blue)),
            Positioned(
                top: size.height * 0.4,
                left: size.width * 0.25,
                child: Icon(Icons.star, color: Colors.blue)),
            Positioned(
                top: size.height * 0.4,
                left: size.width * 0.3,
                child: Icon(Icons.star, color: Colors.black12)),
            Positioned(
                top: size.height * 0.36,
                left: size.width * 0.68,
                child: Container(
                  width: size.width * 0.13,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                      icon: Icon(Icons.share, color: Colors.white, size: 24),
                      onPressed: () async {
                        await Share.share(widget.dataProduct["image"][_image]);
                      }),
                )),
            Positioned(
              top: size.height * 0.44,
              left: size.width * 0.0,
              right: size.width * 0.0,
              child: Container(
                width: size.width,
                child: ListTile(
                  title: Text(
                    "${widget.dataProduct["title"]}",
                    style: TextStyle(fontSize: 18, color: Colors.blue[600]),
                  ),
                  subtitle: Text(
                    "${widget.dataProduct["subtitle"]}",
                    style: TextStyle(fontSize: 16, color: Colors.blue[300]),
                  ),
                  trailing: Text(
                      "R\S${widget.dataProduct["price"].toString().replaceAll(".", ",")} por Hora",
                      style: TextStyle(fontSize: 14, color: Colors.blue[200])),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.56,
              child: Container(
                  width: size.width * 0.25,
                  height: size.height * 0.05,
                  child: TextFormField(
                      controller: _cepDestinoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "CEP",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(10))))),
            ),
            //Divider(height: size.height * 0.05, color: Colors.white),
            Positioned(
              top: size.height * 0.6,
              child: TextButton(
                  onPressed: () async {
                    CalcularFrete calcularFrete = CalcularFrete();
                    await calcularFrete.consultaCEP(
                        _cepDestinoController.text,
                        widget.dataProduct["cep_origem"],
                        widget.dataProduct["latitude"],
                        widget.dataProduct["longetude"]);
                    setState(() {
                      destino = calcularFrete.diference;
                    });
                  },
                  child: Text("Calcular frete")),
            ),
            Positioned(
              top: size.height * 0.62,
              left: size.width * 0.5,
              child: AnimatedCrossFade(
                  firstChild: Text(""),
                  secondChild: Text(
                      "*Até ${(destino / 1000).toStringAsFixed(2)} KM ao destino",
                      style: TextStyle(color: Colors.blue[400])),
                  crossFadeState: destino == 0.0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(seconds: 1)),
            ),
            Positioned(
                top: size.height * 0.67,
                child: Container(
                    width: size.width * 0.9,
                    child: Text(
                      "${widget.dataProduct["describe"]}",
                      style: TextStyle(fontSize: 15, color: Colors.blue[700]),
                    ))),
            Positioned(
                top: size.height * 0.9,
                left: size.width * 0.02,
                right: size.width * 0.02,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        width: size.width * 1,
                        height: size.height * 0.06,
                        child: RaisedButton(
                          child: Text(
                            "Alugue agora",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            await showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                context: context,
                                builder: (context) {
                                  return Container(
                                      width: size.width,
                                      height: size.height * 0.3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            "https://blog.pluga.co/uploads/2020/07/mercado-pago-logo.png",
                                            width: size.width * 0.9,
                                          )
                                        ],
                                      ));
                                });
                          },
                        ))))
          ],
        ),
      ),
    ));
  }
}
