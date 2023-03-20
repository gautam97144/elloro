import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/appconstant/string_variable.dart';
import 'package:elloro/widget/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 12.h,
        title:
            Text(StringConstant.accountInfo, style: CustomTextStyle.headline2),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: CustomPadding(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  StringConstant.date,
                  style: CustomTextStyle.body1,
                ),
                Text(StringConstant.description, style: CustomTextStyle.body1),
                Text(StringConstant.balance, style: CustomTextStyle.body1),
              ],
            )
          ],
        ),
      ),
    );
  }
}
