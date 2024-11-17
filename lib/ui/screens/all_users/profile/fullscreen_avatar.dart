import 'package:flutter/material.dart';

class FullscreenAvatar extends StatelessWidget {
  final String imageUrl;

  const FullscreenAvatar({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(52),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
