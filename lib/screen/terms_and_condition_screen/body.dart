// import 'package:elloro/appconstant/custom_textstyle.dart';
// import 'package:elloro/appconstant/string_variable.dart';
// import 'package:elloro/widget/custom_padding.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class Body extends StatefulWidget {
//   const Body({Key? key}) : super(key: key);
//
//   @override
//   _BodyState createState() => _BodyState();
// }
//
// class _BodyState extends State<Body> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPadding(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           termsAndConditionTitle(),
//           SizedBox(
//             height: 2.h,
//           ),
//           termsAndConditionDescribtion()
//         ],
//       ),
//     );
//   }
//
//   Widget termsAndConditionTitle() {
//     return Text(
//       StringConstant.termsAndConditionTitle,
//       style: CustomTextStyle.body3.copyWith(fontWeight: FontWeight.w800),
//     );
//   }
//
//   Widget termsAndConditionDescribtion() {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: Text(
//         StringConstant.termsAndConditionOne,
//         style: CustomTextStyle.body4,
//       ),
//     );
//   }
//
//   // showModalBottomSheet(
//   //     shape: RoundedRectangleBorder(
//   //     borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//   // backgroundColor: Colors.white,
//   // context: context,
//   // builder: (context) {
//   //   return Column(){}
//   // }
//
// }
