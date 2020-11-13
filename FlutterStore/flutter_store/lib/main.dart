import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _item = 0;
  String _name = '';
  int _price = 0;
  MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = MethodChannel('cellToHost');
    _channel.setMethodCallHandler((MethodCall call) {
      if (call.method == 'setItem') {
        List args = call.arguments as List;
        setState(() {
          _item = args[0] as int;
          _name = args[1] as String;
          _price = args[2] as int;
        });
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: 200,
          color: Colors.yellow[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_name',
              ),
              Text(
                '\$${_price / 100.0}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () {
            _channel.invokeMethod('buy', _item);
          },
          child: Text('Buy'),
        ),
      ]),
    );
  }
}
