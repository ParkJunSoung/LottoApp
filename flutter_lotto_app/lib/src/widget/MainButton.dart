import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lotto_app/src/screen/Lotto_WinInfo.dart';
import 'package:flutter_lotto_app/src/screen/MyLottoNumData.dart';
import 'package:flutter_lotto_app/src/screen/QR_result.dart';
import 'package:flutter_lotto_app/src/utils/env.dart';
import 'package:flutter_lotto_app/src/widget/Coin_widget.dart';
import 'package:flutter_lotto_app/src/widget/LottoBallWidget.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:qrscan/qrscan.dart' as scanner; //qrscan 패키지를 scanner 별칭으로 사용.
import 'package:http/http.dart' as http;

class MainButtonWidget extends StatefulWidget {
  @override
  _MainButtonWidgetState createState() => _MainButtonWidgetState();
}

class _MainButtonWidgetState extends State<MainButtonWidget> {
  AdmobReward rewardAd;

  var lottoData;
  var coinCount;

  @override
  void initState() {
    // TODO: implement initState

    rewardAd = AdmobReward(
      adUnitId: Platform.isIOS ? '' : adRewardUnitId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    rewardAd.load();

    getCount();
    winning_result();
    super.initState();
  }

  @override
  void dispose() {
    rewardAd.dispose();
    super.dispose();
  }

  winning_result() async {
    var url = Uri.parse("$app_API/lottoAllList");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        lottoData = jsonDecode(response.body);
      });
    } else {
      // 만약 응답이 OK가 아니면, 에러
      throw Exception('Failed');
    }
  }

  getCount() async {
    coinCount = await storage.read(key: 'coinCount');
    if (coinCount == null) {
      await storage.write(key: 'coinCount', value: 5.toString());
      coinCount = 5;
    } else {
      coinCount = int.parse(coinCount);
    }
    setCoinCount(coinCount);
  }

  minusCoinCount(count) async {
    await storage.write(key: 'coinCount', value: count.toString());
    setCoinCount(count);
  }

  chargeCoinCount() async {
    await storage.write(key: 'coinCount', value: 5.toString());
    setCoinCount(5);
  }

  setCoinCount(count) {
    setState(() {
      coinCount = count;
    });
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) async {
    switch (event) {
      case AdmobAdEvent.loaded:
        Logger().d('admob loaded');
        break;
      case AdmobAdEvent.opened:
        Logger().d('admob opened');
        break;
      case AdmobAdEvent.closed:
        Logger().d('admob closed');
        break;
      case AdmobAdEvent.failedToLoad:
        Logger().d('admob FailedToLOad');
        break;
      case AdmobAdEvent.rewarded:
        chargeCoinCount();
        showSnackBar('하트가 충전되었습니다.');

        Get.back();

        break;
      default:
    }
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  Future qrscan() async {
    //스캔 시작 - 이때 스캔 될때까지 blocking
    String barcode = await scanner.scan();
    //스캔 완료하면 결과페이지 이동
    Get.to(QRscanResultScreen(
      data: barcode,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return coinCount == null
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.amber[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: qrscan,
                  child: Text('QR 스캔'),
                ),
                FlatButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.amber[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    if (lottoData != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ), //this right here
                            child: Container(
                              height: 250,
                              child: ListView.separated(
                                itemCount: lottoData.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.back();
                                      Get.to(LottoWinInfoScreen(
                                        data: lottoData[index],
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "${lottoData[index]['drwNo'].toString()} 회차",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Divider(color: Colors.black45),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Text('회차별 당첨번호'),
                ),
                FlatButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.amber[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () async {
                    if (coinCount != 0) {
                      minusCoinCount(coinCount - 1);

                      setState(() {
                        coinCount = coinCount - 1;
                      });

                      List<int> lottoNum = [];

                      for (var i = 0; i < 6; i++) {
                        var lotto = Random().nextInt(45) + 1;
                        lottoNum.contains(lotto) ? i-- : lottoNum.add(lotto);
                      }

                      var json = jsonEncode({
                        'drwtNo1': lottoNum[0],
                        'drwtNo2': lottoNum[1],
                        'drwtNo3': lottoNum[2],
                        'drwtNo4': lottoNum[3],
                        'drwtNo5': lottoNum[4],
                        'drwtNo6': lottoNum[5],
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            insetPadding: EdgeInsets.symmetric(horizontal: 20),
                            title: Text(
                              '행운의 추천번호 !!!\n',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            content: LottoBallWidget(data: jsonDecode(json)),
                            actions: [
                              FlatButton(
                                child: new Text(
                                  "닫기",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: new Text(
                                  "번호 저장",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  var array = [];
                                  var readRes =
                                      await storage.read(key: 'randomLotto');

                                  if (readRes == null) {
                                    array.add(jsonDecode(json));
                                  } else {
                                    array = jsonDecode(readRes);
                                    array.add(jsonDecode(json));
                                  }

                                  await storage.write(
                                      key: 'randomLotto',
                                      value: jsonEncode(array));

                                  Get.back();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              '하트가 부족합니다!',
                              style: TextStyle(color: Colors.red[400]),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              "광고 시청 후 하트충천 하기",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              FlatButton(
                                child: new Text(
                                  "닫기",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: new Text(
                                  "시청하기",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  rewardAd.show();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('추천번호 받기'),
                ),
                FlatButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.amber[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () => Get.to(MyLottoNumberScreen()),
                  child: Text('내가 저장한 추천번호'),
                ),
                CoinIconWidget(
                  coinCount: coinCount,
                ),
              ],
            ),
          );
  }
}
