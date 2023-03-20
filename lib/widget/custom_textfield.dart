import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInPutField extends StatefulWidget {
  final TextEditingController? fieldController;
  final String? fieldName;
  final TextCapitalization? textCapitalization;
  final String? hint;
  Function()? onEditingComplete;
  final TextStyle? style;
  final bool? readOnly;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextInputType? fieldInputType;
  // final int? maxLength;
  final FormFieldValidator<String>? validator;
  final int? maxline;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final double? contentpadding;
  final Color? cursorcolor;
  final TextStyle? hintStyle;
  final double? cursorHeight;
  final List<TextInputFormatter>? inputFormatter;
  final bool? autofocus;

  CustomInPutField(
      {Key? key,
      this.fieldName,
      this.textCapitalization,
      this.fieldInputType,
      this.fieldController,
      this.validator,
      this.hint,
      this.focusNode,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText,
      this.contentpadding,
      this.cursorcolor,
      this.hintStyle,
      this.cursorHeight,
      this.autofocus,
      this.style,
      this.onEditingComplete,
      this.readOnly,
      this.maxLength,
      this.inputFormatter,
      this.maxline})
      : super(key: key);

  @override
  _CustomInPutFieldState createState() => _CustomInPutFieldState();
}

class _CustomInPutFieldState extends State<CustomInPutField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatter,
      readOnly: widget.readOnly ?? false,
      maxLines: widget.maxline ?? 1,
      autofocus: widget.autofocus ?? false,
      style: CustomTextStyle.body5,
      cursorColor: AppColor.primarycolor,
      onEditingComplete: widget.onEditingComplete,
      cursorHeight: widget.cursorHeight,
      controller: widget.fieldController,
      keyboardType: widget.fieldInputType ?? TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      validator: widget.validator,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: AppColor.grey.withOpacity(.12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.grey.withOpacity(.22))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:const  BorderSide(color: AppColor.primarycolor)),
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:const  BorderSide(color: Colors.grey)),
        //  focusColor: AppColor.primarycolor
      ),
    );
  }
}
