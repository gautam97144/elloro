import 'package:elloro/appconstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PopUp extends StatefulWidget {
  Widget? title;
  Widget? content;

  PopUp({Key? key, this.title, this.content}) : super(key: key);

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.symmetric(horizontal: 30),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: AppColor.black,
      title: widget.title,
      content: widget.content,
      //child: widget.content,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
