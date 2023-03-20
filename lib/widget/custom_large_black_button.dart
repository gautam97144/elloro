import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';

class CustomLargeBlackButton extends StatefulWidget {
  final Widget title;
  Function()? onPressed;
  Color? color;
  FocusNode? focusNode;
  bool? isPressed;

  CustomLargeBlackButton(
      {Key? key,
      required this.title,
      this.onPressed,
      this.color,
      this.focusNode,
      this.isPressed})
      : super(key: key);

  @override
  _CustomLargeBlackButtonState createState() => _CustomLargeBlackButtonState();
}

class _CustomLargeBlackButtonState extends State<CustomLargeBlackButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
          // autofocus: true,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26)),
              primary: AppColor.primarycolor,
              onSurface: AppColor.primarycolor),
          // ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all(AppColor.primarycolor),
          //     shape: MaterialStateProperty.all(
          //     RoundedRectangleBorder(
          //         //   side: BorderSide(color: AppColor.grey.withOpacity(opacity)),
          //         borderRadius: BorderRadius.circular(26)
          //     )
          //     )
          // ),
          onPressed: widget.onPressed,
          child: widget.title),
    );
  }
}
