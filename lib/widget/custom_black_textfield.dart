import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/widget/texteditingcontroller.dart';
import 'package:flutter/material.dart';

class CustomBlackInPutField extends StatefulWidget {
  final TextEditingController? fieldController;
  final String? fieldName;
  final TextCapitalization? textCapitalization;
  final String? hint;
  final TextInputType? fieldInputType;
  // final int? maxLength;
  final FormFieldValidator<String>? validator;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  Function()? ontap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final double? contentpadding;
  final Color? cursorcolor;
  final TextStyle? hintStyle;
  final double? cursorHeight;
  // final List<TextInputFormatter>? inputFormatter;
  final bool? autofocus;

  CustomBlackInPutField(
      {Key? key,
      this.fieldName,
      this.textCapitalization,
      this.fieldInputType,
      this.fieldController,
      this.validator,
      this.hint,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText,
      this.contentpadding,
      this.cursorcolor,
      this.hintStyle,
      this.cursorHeight,
      this.autofocus,
      this.onChanged,
      this.ontap,
      this.onFieldSubmitted})
      : super(key: key);

  @override
  _CustomBlackInPutFieldState createState() => _CustomBlackInPutFieldState();
}

class _CustomBlackInPutFieldState extends State<CustomBlackInPutField> {
  MyTextController myTextController = MyTextController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus ?? false,
      style: CustomTextStyle.body5,
      cursorColor: AppColor.primarycolor,
      cursorHeight: widget.cursorHeight,
      controller: widget.fieldController,
      keyboardType: widget.fieldInputType ?? TextInputType.text,
      textInputAction: TextInputAction.search,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      validator: widget.validator ?? null,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: AppColor.white,
        ),

        contentPadding: EdgeInsets.only(top: 5, bottom: 5),
        suffixIcon: widget.suffixIcon,

        //widget.suffixIcon,

        // IconButton(
        //   color: AppColor.grey,
        //   icon: Icon(
        //     Icons.cancel_outlined,
        //     size: 25,
        //   ),
        //   onPressed: () {
        //     MyTextController().searchController.clear();
        //   },
        // ),
        filled: true,
        fillColor: AppColor.black,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColor.grey.withOpacity(.22))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColor.black)),
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey)),
        //  focusColor: AppColor.primarycolor
      ),
    );
  }
}
