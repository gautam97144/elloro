import 'package:flutter/material.dart';

class CustomPadding extends StatefulWidget {
  Widget? child;
  CustomPadding({Key? key, this.child}) : super(key: key);

  @override
  _CustomPaddingState createState() => _CustomPaddingState();
}

class _CustomPaddingState extends State<CustomPadding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: widget.child,
    );
  }
}
