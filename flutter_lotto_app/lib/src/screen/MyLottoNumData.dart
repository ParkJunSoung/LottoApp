import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lotto/src/utils/env.dart';
import 'package:flutter_lotto/src/widget/Loading.dart';
import 'package:flutter_lotto/src/widget/LottoBallWidget.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MyLottoNumberScreen extends StatefulWidget {
  @override
  _MyLottoNumberScreenState createState() => _MyLottoNumberScreenState();
}

class _MyLottoNumberScreenState extends State<MyLottoNumberScreen> {
  var randomLottoList;
  var weekLottoData = [];
  var bonusNo;

  @override
  void initState() {
    // TODO: implement initState
    weekLottoData = [
      Get.arguments['drwtNo1'],
      Get.arguments['drwtNo2'],
      Get.arguments['drwtNo3'],
      Get.arguments['drwtNo4'],
      Get.arguments['drwtNo5'],
      Get.arguments['drwtNo6']
    ];
    bonusNo = Get.arguments['bnusNo'];
    storageDataGet();
    super.initState();
  }

  void storageDataGet() async {
    randomLottoList = await storage.read(key: 'randomLotto');
    setState(() {
      if (randomLottoList == null) {
        randomLottoList = [];
      } else {
        randomLottoList = jsonDecode(randomLottoList);
      }
    });
  }

  void removeMyLottoNum(lottoArrIndex) async {
    var array = randomLottoList;

    array.removeAt(lottoArrIndex);

    if (array.length > 0) {
      await storage.write(key: 'randomLotto', value: jsonEncode(array));
    } else {
      var arr = [];
      await storage.write(key: 'randomLotto', value: jsonEncode(arr));
    }

    randomLottoList = await storage.read(key: 'randomLotto');

    setState(() {
      randomLottoList = jsonDecode(randomLottoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text('내가 저장한 번호'),
      ),
      body: randomLottoList == null
          ? LoadingScreen()
          : randomLottoList.length == 0
              ? Container(
                  child: Center(
                    child: Text('저장된 번호가 없습니다.'),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    var winText;
                    var myLotto = [
                      randomLottoList[index]['drwtNo1'],
                      randomLottoList[index]['drwtNo2'],
                      randomLottoList[index]['drwtNo3'],
                      randomLottoList[index]['drwtNo4'],
                      randomLottoList[index]['drwtNo5'],
                      randomLottoList[index]['drwtNo6'],
                    ];

                    var arr = myLotto;

                    for (int i = 0; i < weekLottoData.length; i++) {
                      for (int j = 0; j < myLotto.length; j++) {
                        if (weekLottoData[i] == myLotto[j]) {
                          arr.remove(myLotto[j]);
                        }
                      }
                    }

                    if (arr.length == 0) {
                      winText = '1 등 당첨 !!!';
                    }

                    if (arr.length == 1) {
                      if (arr[0] == bonusNo) {
                        winText = '2 등 당첨 !!!';
                      } else {
                        winText = '3 등 당첨 !!!';
                      }
                    }

                    if (arr.length == 2) {
                      winText = '4 등 당첨 !!!!';
                    }

                    if (arr.length == 3) {
                      winText = '5 등 당첨 !!!';
                    }

                    if (arr.length > 3) {
                      winText = '꽝';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.blueGrey[100],
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: LottoBallWidget(
                                    data: randomLottoList[index],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      removeMyLottoNum(index);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 17.0, bottom: 17.0),
                                    child: Text(
                                      '이번주 당첨 번호와 비교 :',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 20.0, bottom: 17.0),
                                    child: Text(
                                      winText,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: winText != '꽝'
                                              ? Colors.red
                                              : Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: randomLottoList.length,
                ),
    );
  }
}
