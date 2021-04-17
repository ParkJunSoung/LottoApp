import 'package:flutter/material.dart';

class CoinIconWidget extends StatelessWidget {
  final coinCount;
  const CoinIconWidget({Key key, this.coinCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite,
          color: coinCount >= 1 ? Colors.red : Colors.grey,
          size: 35,
        ),
        SizedBox(
          width: 17,
        ),
        Icon(
          Icons.favorite,
          color: coinCount >= 2 ? Colors.red : Colors.grey,
          size: 35,
        ),
        SizedBox(
          width: 17,
        ),
        Icon(
          Icons.favorite,
          color: coinCount >= 3 ? Colors.red : Colors.grey,
          size: 35,
        ),
        SizedBox(
          width: 17,
        ),
        Icon(
          Icons.favorite,
          color: coinCount >= 4 ? Colors.red : Colors.grey,
          size: 35,
        ),
        SizedBox(
          width: 17,
        ),
        Icon(
          Icons.favorite,
          color: coinCount == 5 ? Colors.red : Colors.grey,
          size: 35,
        ),
      ],
    );
  }
}
