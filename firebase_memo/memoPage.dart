import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/memoDetail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL = 'https://basicproject-30224-default-rtdb.firebaseio.com/';
  List<Memo> memos = List.empty(growable: true);
  
  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(databaseURL: _databaseURL, app: Firebase.app());
    reference = _database!.ref().child('memo');
    
    reference!.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 앱'),
      ),
      body: Center(
        child: memos.isEmpty
            ? const CircularProgressIndicator()
            : GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Card(
                child: GridTile(
                  header: Text(memos[index].title),
                  footer: Text(memos[index].createTime.substring(0,10)),
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: () async {
                          Memo? memo = await Navigator.of(context).push(
                            MaterialPageRoute<Memo>(
                                builder: (BuildContext context) => MemoDetailPage(reference!, memos[index])));
                          if (memo != null) {
                            setState(() {
                              memos[index].title = memo.title;
                              memos[index].content = memo.content;
                            });
                          }
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(memos[index].title),
                                  content: const Text('삭제하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          reference!
                                              .child(memos[index].key!)
                                              .remove()
                                              .then((_) {
                                                setState(() {
                                                  memos.removeAt(index);
                                                  Navigator.of(context).pop();
                                                });
                                          });
                                        },
                                        child: const Text('예')),
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                        child: const Text('아니요')),
                                  ],
                                );
                          });
                        },
                        child: Text(memos[index].content),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: memos.length,
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemoAddPage(reference!)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}