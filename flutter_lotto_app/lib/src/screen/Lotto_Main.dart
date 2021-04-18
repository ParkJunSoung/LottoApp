import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lotto/src/utils/env.dart';
import 'package:flutter_lotto/src/widget/Loading.dart';
import 'package:flutter_lotto/src/widget/MainButton.dart';
import 'package:flutter_lotto/src/widget/WeekWinNum.dart';

import 'package:http/http.dart' as http;

class LottoMainScreen extends StatefulWidget {
  @override
  _LottoMainScreenState createState() => _LottoMainScreenState();
}

class _LottoMainScreenState extends State<LottoMainScreen> {
  AdmobBannerSize bannerSize;
  var data;

  @override
  void initState() {
    // TODO: implement initState
    bannerSize = AdmobBannerSize.BANNER;

    lottoTotalResult();
    super.initState();
  }

  lottoTotalResult() async {
    var url = Uri.parse("$app_API/recentlyData");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)[0];
      });
    } else {
      // 만약 응답이 OK가 아니면, 에러
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              centerTitle: true,
              title: Text(
                '${data['drwNoDate']} / ${data['drwNo']} 회차',
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));
                  },
                  icon: Icon(Icons.refresh),
                )
              ],
            ),
            body: ListView(
              children: [
                WeekWinNumWidget(
                  data: data,
                ),
                MainButtonWidget(),
                SizedBox(height: 7),
                Container(
                  height: 60,
                  child: AdmobBanner(
                    adUnitId: Platform.isIOS ? '' : adBannerUnitId,
                    adSize: bannerSize,
                  ),
                ),
              ],
            ),
          );
  }
}
