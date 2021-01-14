//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:linger/src/pages/home/functions/add_product.dart';

class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  //---- Variables

  List _images = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _cepOrigemController = TextEditingController();
  TextEditingController _especificationController = TextEditingController();

  var _form = GlobalKey<FormState>();
  var _snack = GlobalKey<ScaffoldState>();

  //---- Functions

  Future image() async {
    var imagePicker = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _images.insert(_images.length, imagePicker.path);
    });
  }

  Future galery() async {
    var imagePicker = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _images.insert(_images.length, imagePicker.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _snack,
        body: Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.white),
                    IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Colors.blue, size: size.width * 0.11),
                        onPressed: () => Navigator.pop(context)),
                    Divider(color: Colors.white),
                    _images.length >= 1
                        ? CarouselSlider.builder(
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Stack(
                                    alignment: Alignment(1, 1),
                                    children: [
                                      Image.file(
                                        File(_images[index]),
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.fill,
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          })
                                    ],
                                  ));
                            },
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                autoPlay: true,
                                initialPage: 0,
                                onPageChanged: (context, index) =>
                                    print(context)))
                        : Center(
                            child: Text(
                              "Adicone uma imagem",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                    _images.length >= 1
                        ? Center(
                            child: Text(
                                "Quantidade de imagens: ${_images.length}",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 16)),
                          )
                        : Text(""),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            tooltip: "Adicionar Imagem da camerâ",
                            icon: Icon(Icons.camera, color: Colors.blue),
                            onPressed: () async {
                              await image();
                            }),
                        IconButton(
                            tooltip: "Adicionar Imagem da galeria",
                            icon: Icon(Icons.attachment, color: Colors.blue),
                            onPressed: () async {
                              await galery();
                            }),
                      ],
                    ),
                    formulario(
                        "Digite o título",
                        1,
                        _titleController,
                        TextInputType.text,
                        false,
                        TextCapitalization.words,
                        size.height * 0.06),
                    Divider(color: Colors.white),
                    formulario(
                        "Digite o Subtitulo",
                        1,
                        _subtitleController,
                        TextInputType.text,
                        false,
                        TextCapitalization.sentences,
                        size.height * 0.06),
                    Divider(color: Colors.white),
                    formulario(
                        "Digite o preço por hora",
                        1,
                        _priceController,
                        TextInputType.number,
                        false,
                        TextCapitalization.words,
                        size.height * 0.06),
                    Divider(color: Colors.white),
                    formulario(
                        "Digite o CEP de origem",
                        1,
                        _cepOrigemController,
                        TextInputType.number,
                        false,
                        TextCapitalization.words,
                        size.height * 0.06),
                    Divider(color: Colors.white),
                    formulario(
                        "Informe sobre a descrição do produto",
                        40,
                        _describeController,
                        TextInputType.multiline,
                        false,
                        TextCapitalization.sentences,
                        size.height * 0.21),
                    Divider(color: Colors.white),
                    formulario(
                        "Informe as especificações do produto",
                        20,
                        _especificationController,
                        TextInputType.multiline,
                        false,
                        TextCapitalization.sentences,
                        size.height * 0.16),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                    width: size.width * 0.5,
                                    height: size.height * 0.06,
                                    child: RaisedButton.icon(
                                        color: Colors.blue,
                                        onPressed: () async {
                                          if (_form.currentState.validate()) {
                                            _snack.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "Adicionando produto  ${_titleController.text}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              duration: Duration(seconds: 10),
                                              backgroundColor: Colors.blue,
                                            ));
                                            final position = await Geolocator
                                                .getCurrentPosition();
                                            AddProduct addProduct =
                                                AddProduct();
                                            var id = DateTime.now().toString();
                                            await addProduct.addPhoto(
                                                _images, id);

                                            await addProduct.addProduct(
                                                _titleController.text,
                                                _subtitleController.text,
                                                _describeController.text,
                                                _priceController.text,
                                                _cepOrigemController.text,
                                                id,
                                                position.latitude,
                                                position.longitude);
                                            await Navigator.pop(context);
                                          }
                                        },
                                        splashColor: Colors.white,
                                        icon: Icon(Icons.check,
                                            color: Colors.white),
                                        label: Text("Alugar produto",
                                            style: TextStyle(
                                                color: Colors.white)))))))
                  ],
                ),
              ),
            )));
  }

  Widget formulario(
      String hintText,
      int maxLines,
      TextEditingController controller,
      TextInputType textInputType,
      bool prefix,
      TextCapitalization textCapitalization,
      double size) {
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: size,
              color: Colors.blue,
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Está vazio";
                  }
                },
                controller: controller,
                keyboardType: textInputType,
                textAlign: TextAlign.start,
                textCapitalization: textCapitalization,
                maxLines: maxLines,
                cursorColor: Colors.green[900],
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    contentPadding: EdgeInsets.only(
                        left: 20, top: size * 0.1, bottom: size * 0.1),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.white),
                    prefixText: prefix ? "R\$" : null,
                    fillColor: Colors.white),
              ),
            )));
  }
}
