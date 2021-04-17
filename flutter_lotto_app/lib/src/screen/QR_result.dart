import 'package:flutter/material.dart';

class QRscanResultScreen extends StatelessWidget {
  final data;
  const QRscanResultScreen({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
