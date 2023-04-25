import 'package:flutter/material.dart';

class Calc extends StatefulWidget {
  const Calc({Key? key}) : super(key: key);

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  String sum = '';
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();

  final List _buttonList = ['+', '-', 'X', '%'];
  final List<DropdownMenuItem<String>> _dropDownMenuItems =
      List.empty(growable: true);
  String? _buttonText;

  @override
  void initState() {
    super.initState();
    for (var item in _buttonList) {
      _dropDownMenuItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    _buttonText = _dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Result : $sum',
              style: const TextStyle(fontSize: 20),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: value1,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: value2,
            ),
            DropdownButton(
              items: _dropDownMenuItems,
              onChanged: (String? value) {
                setState(() {
                  _buttonText = value;
                });
              },
              value: _buttonText,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    var value1Int = double.parse(value1.value.text);
                    var value2Int = double.parse(value2.value.text);
                    var result = 0.0;
                    if (_buttonText == "+") {
                      result = value1Int + value2Int;
                    } else if (_buttonText == "-") {
                      result = value1Int - value2Int;
                    } else if (_buttonText == "X") {
                      result = value1Int * value2Int;
                    } else {
                      result = value1Int / value2Int;
                    }
                    sum = '$result';
                  });
                },
                child: Text(_buttonText!))
          ],
        ),
      ),
    );
  }
}
