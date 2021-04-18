import 'package:flutter/material.dart';
import 'package:flutter_lotto/src/utils/price_utils.dart';
import 'package:flutter_lotto/src/widget/LottoBallWidget.dart';

class WeekWinNumWidget extends StatelessWidget {
  final data;
  const WeekWinNumWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '총 상금액 : ' +
                PriceUtils.calcStringToWon(data['totSellamnt'].toString()),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            '1등 상금액 : ' +
                PriceUtils.calcStringToWon(data['firstWinamnt'].toString()),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            '당첨인원 : ${data['firstPrzwnerCo']} 명',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          LottoBallWidget(
            data: data,
          ),
        ],
      ),
    );
  }
}
