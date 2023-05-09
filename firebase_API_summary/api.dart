import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tour.dart';

class MyAPI extends StatefulWidget {
  const MyAPI({Key? key}) : super(key: key);

  @override
  State<MyAPI> createState() => _MyAPIState();
}

class _MyAPIState extends State<MyAPI> {
  List<TourData> tourData = List.empty(growable: true);
  String title = '';
  String address = '';
  String zipcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("API Page"),
            Text(title!),
            Text(address!),
            Text(zipcode!),
            ElevatedButton(
                onPressed: () {
                  getAreaList(area: 1, contentTypeId: 12, page: 1);
                },
                child: const Text("connect API")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text("Go Login Page")),
          ],
        ),
      ),
    );
  }

  void getAreaList(
      {required int area,
      required int contentTypeId,
      required int page}) async {
    String authKey =
        'xEZPmx1DChj5njfuARu%2FvuZu2M%2FoWV1i6S7%2B1n8uFXzb8G4%2FHddhmPwTDXfNBdIn%2FUb6duu2t2VBTISpBQlM%2BA%3D%3D';

    var url = 'http://api.visitkorea.or.kr/openapi/service/rest/KorService/'
        'areaBasedList?ServiceKey=$authKey&MobileOS=AND&MobileApp=ModuTour&'
        '_type=json&areaCode=1&numOfRows=10&sigunguCode=$area&pageNo=$page';
    /*
              'http://apis.data.go.kr/B551011/KorService1/'
              'areaBasedList1?ServiceKey=$authKey&MobileOS=AND&MobileApp=ModuTour&'
              '_type=json&areaCode=1&numOfRows=10&sigunguCode=$area&pageNo=$page';

     */

    if (contentTypeId != 0) {
      url = '$url&contentTypeId=$contentTypeId';
    }
    var response = await http.get(Uri.parse(url));
    String body = utf8.decode(response.bodyBytes);
    print(body);
    var json = jsonDecode(body);
    if (json['response']['header']['resultCode'] == "0000") {
      if (json['response']['body']['items'] == '') {
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('마지막 데이터 입니다'),
                );
              });
        }
      } else {
        List jsonArray = json['response']['body']['items']['item'];
        for (var s in jsonArray) {
          setState(() {
            tourData.add(TourData.fromJason(s));

              title = tourData[1].title!;
              address = tourData[1].address!;
            zipcode = tourData[1].zipcode!;
          });
        }
      }
    } else {
      print('error');
    }
  }
}
