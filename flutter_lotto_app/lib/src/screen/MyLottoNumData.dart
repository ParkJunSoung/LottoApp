import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lotto/src/utils/env.dart';
import 'package:flutter_lotto/src/widget/Loading.dart';
import 'package:flutter_lotto/src/widget/LottoBallWidget.dart';

class MyLottoNumberScreen extends StatefulWidget {
  @override
  _MyLottoNumberScreenState createState() => _MyLottoNumberScreenState();
}

class _MyLottoNumberScreenState extends State<MyLottoNumberScreen> {
  var randomLottoList;

  @override
  void initState() {
    // TODO: implement initState
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
                    var lottoNum = randomLottoList[index];
                    lottoNum['index'] = index;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.blueGrey[100],
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: LottoBallWidget(
                                data: randomLottoList[index],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  removeMyLottoNum(lottoNum['index']);
                                },
                                icon: Icon(Icons.delete))
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
