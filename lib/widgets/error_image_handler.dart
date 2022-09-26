import 'package:flutter/material.dart';

Widget imageErrorHandler(BuildContext context, Object? exception,
    StackTrace? stackTrace) {
  return Container(
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.width * 0.4,
    padding: const EdgeInsets.all(10),
    child: const Text('Sorry, Unable to Load Image',textAlign: TextAlign.center,),
  );
}