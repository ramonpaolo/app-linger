import 'package:flutter/material.dart';

Widget subPage(String pathImage, String text, Size size) {
  return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Image.network(
            pathImage,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )
        ],
      ));
}
