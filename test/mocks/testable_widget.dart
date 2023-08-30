import 'package:flutter/material.dart';

Type typeOf<T>() => T;

/// Create a widget that can be tested
Widget makeTestableWidget({required Widget child}) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      home: child,
      builder: (context, child) => Scaffold(
        body: child,
      ),
    ),
  );
}
