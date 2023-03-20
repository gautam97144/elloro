import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CoustomSmallBlackButton extends StatefulWidget {
  String title;
  Function()? onPressed;
  Color? color;
  TextStyle? style;

  CoustomSmallBlackButton(
      {Key? key, this.color, required this.title, this.onPressed, this.style})
      : super(key: key);

  @override
  _CoustomSmallBlackButtonState createState() =>
      _CoustomSmallBlackButtonState();
}

class _CoustomSmallBlackButtonState extends State<CoustomSmallBlackButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      height: 6.h,
      child: TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            //overlayColor: MaterialStateProperty.all(Colors.green),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: BorderSide(color: AppColor.grey.withOpacity(.5)),
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
