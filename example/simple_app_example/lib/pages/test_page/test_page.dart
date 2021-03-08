import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String text;
  TestPage(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text),
              ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('one'), child: Text('01'),),
              ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('two'), child: Text('02'),),
              ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('three'), child: Text('03'),),
              ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('four'), child: Text('04'),),
            ],
          ),
        )
      ),
    );
  }
}