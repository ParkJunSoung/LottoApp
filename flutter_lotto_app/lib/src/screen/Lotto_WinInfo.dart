import 'package:flutter/material.dart';
import 'package:flutter_lotto/src/widget/WeekWinNum.dart';

class LottoWinInfoScreen extends StatelessWidget {
  final data;
  const LottoWinInfoScreen({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          '${data['drwNoDate']} / ${data['drwNo']} 회차',
        ),
      ),
      body: Center(
        child: WeekWinNumWidget(
          data: data,
        ),
      ),
    );
  }
}
