import 'package:elloro/screen/thank_you_screen/body.dart';
import 'package:flutter/material.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  _ThankYouScreenState createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Body(),
    );
  }
}
