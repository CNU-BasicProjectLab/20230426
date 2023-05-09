import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:modu_tour/data/tour.dart';
import 'package:modu_tour/data/listData.dart';
import 'package:sqflite/sqflite.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference? databaseReference;
  final Future<Database>? db;
  final String? id;

  const MapPage({Key? key, this.databaseReference, this.db, this.id})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<DropdownMenuItem<Item>> list = List.empty(growable: true);
  List<DropdownMenuItem<Item>> sublist = List.empty(growable: true);
  List<TourData> tourData = List.empty(growable: true);
  ScrollController? _scrollController;

  String authKey =
      'xEZPmx1DChj5njfuARu%2FvuZu2M%2FoWV1i6S7%2B1n8uFXzb8G4%2FHddhmPwTDXfNBdIn%2FUb6duu2t2VBTISpBQlM%2BA%3D%3D';

  Item? area;
  Item? kind;
  int page = 1;

  @override
  void initState() {
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;

    area = list[0].value;
    kind = sublist[0].value;

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        page++;
        getAreaList(area: area!.value, contentTypeId: kind!.value, page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색하기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DropdownButton(
                  items: list,
                  onChanged: (value) {
                    Item selectedItem = value!;
                    setState(() {
                      area = selectedItem;
                    });
                  },
                  value: area,
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<Item>(
                  items: sublist,
                  onChanged: (value) {
                    Item selectedItem = value!;
                    setState(() {
                      kind = selectedItem;
                    });
                  },
                  value: kind,
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    page = 1;
                    tourData.clear();
                    getAreaList(
                        area: area!.value,
                        contentTypeId: kind!.value,
                        page: page);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent)),
                  child: const Text(
                    '검색하기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        Hero(
                            tag: 'tourinfo$index',
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: getImage(
                                            tourData[index].imagePath))))),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                tourData[index].title!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text('주소 : ${tourData[index].address}'),
                              tourData[index].tel != null
                                  ? Text('전화번호 : ${tourData[index].tel}')
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                    onDoubleTap: () {
                      insertTour(widget.db!, tourData[index]);
                    },
                  ),
                );
              },
              itemCount: tourData.length,
              controller: _scrollController,
            ))
          ],
        ),
      ),
    );
  }

  void insertTour(Future<Database> db, TourData info) async {
    final Database database = await db;
    await database
        .insert('place', info.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('츨겨찾기에 추가되었습니다.')));
    });
  }

  ImageProvider getImage(String? imagePath) {
    if (imagePath != null) {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage(('repo/images/map_location.png'));
    }
  }

  void getAreaList(
      {required int area,
      required int contentTypeId,
      required int page}) async {
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
          });
        }
      }
    } else {
      print('error');
    }
  }
}
