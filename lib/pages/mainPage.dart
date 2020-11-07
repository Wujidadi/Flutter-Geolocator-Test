import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import 'package:geolocator_test/helpers/references.dart';

class MainPage extends StatefulWidget {
    @override
    _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    StreamSubscription<Position> positionStream;

    String coordinates;

    double startLatitude;
    double startLongitude;

    double endLatitude = target['y'];
    double endLongitude = target['x'];

    double distance;
    double bearing;

    DateTime time;

    Future<void> initPlatformState() async {
        // Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

        positionStream = getPositionStream(desiredAccuracy: LocationAccuracy.best).listen((Position _position) {
            setState(() {
                coordinates = _position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString();

                startLatitude = _position.latitude;
                startLongitude = _position.longitude;

                distance = distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
                bearing = bearingBetween(startLatitude, startLongitude, endLatitude, endLongitude);

                time = DateTime.now();

                print(time);
                print(coordinates);
                print('Distance: $distance m');
                print('Bearing: $bearing°');
            });
        });

        positionStream.resume();
    }

    /// 點擊返回鍵時跳出警告訊息框
    Future<bool> backExitAlert(BuildContext context) {
        /// 取消按鈕
        Widget cancelButton = FlatButton(
            child: Text('取消'),
            onPressed: () {
                Navigator.of(context).pop(false);
            }
        );

        /// 確定按鈕
        Widget submitButton = FlatButton(
            child: Text('確定'),
            onPressed: () {
                Navigator.of(context).pop(true);
            }
        );

        /// 警告訊息框
        AlertDialog alert = AlertDialog(
            title: Text('退出 GeoLocator 測試'),
            titleTextStyle: TextStyle(
                color: Colors.blue,
                fontSize: 19,
                fontWeight: FontWeight.bold
            ),
            titlePadding: EdgeInsets.fromLTRB(17.5, 12.5, 17.5, 12.5),
            content: Text('確定離開？'),
            contentPadding: EdgeInsets.fromLTRB(17.5, 12.5, 17.5, 12.5),
            actions: <Widget>[
                cancelButton,
                submitButton
            ]
        );

        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                return alert;
            }
        );
    }

    String coordinatesString() {
        if (startLongitude == null || startLatitude == null) {
            return '';
        }
        return '經緯度：$startLongitude, $startLatitude';
    }

    String targetString() {
        /* 取得當前經緯度座標才顯示目的地經緯度座標 */
        if (startLongitude == null || startLatitude == null) {
            return '';
        }
        return '目的地：$endLongitude, $endLatitude';
    }

    String distanceString() {
        if (distance == null) {
            return '';
        }
        return '距離：$distance m';
    }

    String bearingString() {
        if (bearing == null) {
            return '';
        }
        return '方位：$bearing°';
    }

    String timeString() {
        if (bearing == null) {
            return '';
        }
        return '時間：$time';
    }

    @override
    void initState() {
        super.initState();
        initPlatformState();
    }

    @override
    void dispose() {
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async => backExitAlert(context),
            child: Scaffold(
                appBar: AppBar(
                    title: Text('GeoLocator 測試'),
                    centerTitle: true
                ),
                body: Column(
                    children: <Widget>[
                        RichText(
                            text: TextSpan(
                                /* 預設樣式 */
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey
                                ),
                                children: <TextSpan>[
                                    TextSpan(
                                        text: coordinatesString(),
                                        style: TextStyle(
                                            color: Colors.red
                                        )
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: targetString(),
                                        style: TextStyle(
                                            color: Colors.orange[700]
                                        )
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: distanceString(),
                                        style: TextStyle(
                                            color: Colors.amberAccent[700]
                                        )
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: bearingString(),
                                        style: TextStyle(
                                            color: Colors.blue
                                        )
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: timeString(),
                                        style: TextStyle(
                                            color: Colors.green
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}
