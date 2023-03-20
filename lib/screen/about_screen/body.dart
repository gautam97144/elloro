// import 'package:elloro/appconstant/app_images.dart';
// import 'package:elloro/appconstant/custom_textstyle.dart';
// import 'package:elloro/appconstant/string_variable.dart';
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
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             elloroLogo(),
//             SizedBox(
//               height: 3.h,
//             ),
//             aboutText(),
//             SizedBox(
//               height: 3.h,
//             ),
//             aboutTextSecond(),
//             SizedBox(
//               height: 3.h,
//             ),
//             aboutTextThird(),
//             SizedBox(
//               height: 3.h,
//             ),
//             aboutTextFour(),
//             SizedBox(
//               height: 3.h,
//             ),
//             aboutTextFive(),
//             SizedBox(
//               height: 3.h,
//             ),
//             aboutTextSix()
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget elloroLogo() {
//     return Image.asset(
//       Images.logo,
//       scale: 4,
//       fit: BoxFit.fill,
//     );
//   }
//
//   Widget aboutText() {
//     return Text(
//       StringConstant.aboutFirst,
//       style: CustomTextStyle.body4,
//     );
//   }
//
//   Widget aboutTextSecond() {
//     return Text(
//       StringConstant.aboutSecond,
//       style: CustomTextStyle.body4,
//     );
//   }
//
//   Widget aboutTextThird() {
//     return Text(
//       StringConstant.aboutThird,
//       style: CustomTextStyle.body4,
//     );
//   }
//
//   Widget aboutTextFour() {
//     return Text(
//       StringConstant.aboutforth,
//       style: CustomTextStyle.body4,
//     );
//   }
//
//   Widget aboutTextFive() {
//     return Text(
//       StringConstant.aboutfive,
//       style: CustomTextStyle.body4,
//     );
//   }
//
//   Widget aboutTextSix() {
//     return Text(
//       StringConstant.aboutsix,
//       style: CustomTextStyle.body4,
//     );
//   }
// }
