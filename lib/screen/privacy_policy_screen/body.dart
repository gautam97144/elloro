import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Column(
        children: [
          privacyAndPolicyTitle(),
          SizedBox(
            height: 2.h,
          ),
          privacyAndPolicyOne(),
          SizedBox(
            height: 2.h,
          ),
          privacyAndPolicyDescription(),
          SizedBox(
            height: 2.h,
          ),
          privacyThird()
        ],
      ),
    );
  }

  Widget privacyAndPolicyTitle() {
    return Text("This Policy describes how we process your personal data.",
        style: CustomTextStyle.body3.copyWith(fontWeight: FontWeight.w800));
  }

  Widget privacyAndPolicyOne() {
    return Text(StringConstant.privacyOne, style: CustomTextStyle.body4);
  }

  Widget privacyAndPolicyDescription() {
    return Text(StringConstant.privacyTwo,
        style: CustomTextStyle.body4, textAlign: TextAlign.start);
  }

  Widget privacyThird() {
    return Text(StringConstant.privacyThird,
        style: CustomTextStyle.body4, textAlign: TextAlign.start);
  }
}
