import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CoustomSmallButton extends StatefulWidget {
  String title;
  Function()? onPressed;
  Color? color;
  TextStyle? style;

  CoustomSmallButton(
      {Key? key, this.color, required this.title, this.onPressed, this.style})
      : super(key: key);

  @override
  _CoustomSmallButtonState createState() => _CoustomSmallButtonState();
}

class _CoustomSmallButtonState extends State<CoustomSmallButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      height: 6.h,
      child: TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            //overlayColor: MaterialStateProperty.all(Colors.green),
            backgroundColor: MaterialStateProperty.all(AppColor.primarycolor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)))),
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: widget.style,
        ),
      ),
    );
  }
}
