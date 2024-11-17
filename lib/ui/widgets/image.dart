import 'dart:io';

import 'package:flutter/material.dart';

class imageContainer extends StatelessWidget {
  late double height;
  late double width;
  late String? imageLink;
  late File? imageFile;
  late double percent;

  imageContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.percent,
      this.imageLink,
      this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: height * percent,
        height: height * percent,
        decoration: BoxDecoration(
            border: Border.all(width: 4, color: Colors.grey[500]!),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1))
            ],
            shape: BoxShape.circle,
            image: imageFile != null
                ? DecorationImage(
                    fit: BoxFit.contain, image: Image.file(imageFile!).image)
                : (DecorationImage(
                    fit: BoxFit.contain, image: NetworkImage(imageLink!)))));
  }
}
