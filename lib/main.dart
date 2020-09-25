import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Backend',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List lis = [];
  var a;
  var sessionToken = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter - HTTP backend"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                color: Colors.pinkAccent,
                child: Text("Sign up form API CALL"),
                onPressed: _signupFormApiCall),
            MaterialButton(
                color: Colors.deepPurpleAccent,
                child: Text("Concerns API CALL"),
                onPressed: _concernsListApiCall),
          ],
        ),
      ),
    );
  }

  Future<http.Response> _signupFormApiCall() async {
    //signup form

    Map data = {
      'name': 'Karthika',
      'mobile': '9080517780',
      'address': 'new street',
      'state': 'Tamilnadu',
      'district': 'thanjavur',
      'professional': 'Developer',
      'device_latitude': '102',
      'device_longitude': '102',
      'email': 'karthikavel2000@gmail.com',
      'profileUrl': 'https://',
      'deviceType': 'mobile',
      'firebaseToken': '12334',
      'contribution': 'food',
      'imei': '123445',
    };
    var response = await http.post(
        'https://api.savemynation.com/api/partner/savepartner/registervolunteer',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));

    print('result');
    sessionToken = json.decode(response.body)['deviceToken'];
    print(sessionToken);
  }

  Future<List> _concernsListApiCall() async {
//concerrns list
    Map data = {
      'mobile': '9080517780',
      'homeLatitude': '1233',
      'homeLongitude': '1234',
      'deviceToken': sessionToken,
    };
    var response = await http.post(
        'https://api.savemynation.com/api/partner/savepartner/getlistofneeds',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
    print("Response");
    print(response.body);
    var reBody = json.decode(response.body)['messages'];

    return reBody;
  }

  Future<List<ConData>> fun() async {
    a = _concernsListApiCall();
    await a.then((value) {
      for (int i = 0; i < value.length; i++) {
        ConData s = new ConData(
          name: value[i]['name'],
          mobile: value[i]['mobile'],
          address: value[i]['address'],
          district: value[i]['district'],
          state: value[i]['state'],
          type: value[i]['type'],
          comments: value[i]['comments'],
          devicelatitude: value[i]['device_latitude'],
          devicelongitude: value[i]['device_longitude'],
        );
        lis.add(s);

        print(s.type);
        print(lis.length);
      }
    });
  }
}

class ConData {
  String name;
  String mobile;
  String address;
  String state;
  String type;
  String district;
  String comments;
  String devicelatitude;
  String devicelongitude;

  ConData(
      {this.name,
      this.district,
      this.address,
      this.mobile,
      this.state,
      this.type,
      this.comments,
      this.devicelatitude,
      this.devicelongitude});
}
