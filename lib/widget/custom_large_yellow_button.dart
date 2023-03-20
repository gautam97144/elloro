import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';

class CustomLargeButton extends StatefulWidget {
  final Widget title;
  Function()? onPressed;
  Color? color;

  CustomLargeButton({Key? key, required this.title, this.onPressed, this.color})
      : super(key: key);

  @override
  _CustomLargeButtonState createState() => _CustomLargeButtonState();
}

class _CustomLargeButtonState extends State<CustomLargeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: TextButton(
          style: ButtonStyle(
              //overlayColor: MaterialStateProperty.all(Colors.green),
              backgroundColor: MaterialStateProperty.all(AppColor.primarycolor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26)))),
          onPressed: widget.onPressed,
          child: widget.title),
    );
  }
}
