import 'package:flutter/material.dart';

Widget loadingBuilderImage(
    BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  if (loadingProgress == null) {
    return child;
  }
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(40),
    height: MediaQuery.of(context).size.width * 0.4,
    width: MediaQuery.of(context).size.width * 0.4,
    child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
          : null,
    ),
  );
}
