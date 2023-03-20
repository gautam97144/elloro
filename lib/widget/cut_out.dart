import 'package:flutter/material.dart';

class Cutout extends StatelessWidget {
  final Color color;
  final Widget? child;

  Cutout({
    Key? key,
    required this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcOut,
      shaderCallback: (bound) =>
          LinearGradient(colors: [color], stops: [0.0]).createShader(bound),
      child: child,
    );
  }
}
