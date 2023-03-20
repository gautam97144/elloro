import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black.withOpacity(.8),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: AppColor.primarycolor, size: 45),
      ),
    );
  }
}
