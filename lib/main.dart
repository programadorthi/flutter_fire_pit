import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fire pit',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorTween;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.forward(from: 0.0);
        }
      });

    _colorTween = ColorTween(
      begin: new Color(0xFFFDBB01),
      end: new Color(0xFFF36B01),
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Fire pit'),
      ),
      body: new Center(
        child: new SizedBox(
          height: 300.0,
          width: 200.0,
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Container(),
              ),
              new FlameWidget(
                this._animationController,
                this._colorTween,
              ),
              new Stack(
                children: <Widget>[
                  new WoodWidget(rotate: true),
                  new WoodWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlameWidget extends StatelessWidget {
  final AnimationController _animationController;
  final Animation<Color> _colorTween;

  FlameWidget(this._animationController, this._colorTween);

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: _colorTween,
      builder: (BuildContext context, Widget child) {
        return new Transform(
          alignment: FractionalOffset.center,
          transform: new Matrix4.rotationZ(math.pi / 4.0),
          child: new Container(
            height: 100.0 * this._animationController.value,
            width: 100.0 * this._animationController.value,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0),
              color: this._colorTween.value,
              shape: BoxShape.rectangle,
            ),
          ),
        );
      },
    );
  }
}

class WoodWidget extends StatelessWidget {
  final Color color;
  final double radians;
  final List<BoxShadow> shadows;

  WoodWidget({bool rotate: false})
      : color = rotate ? new Color(0xFF612E25) : new Color(0xFF70392F),
        radians = rotate ? -math.pi : math.pi,
        shadows = <BoxShadow>[
          new BoxShadow(
            blurRadius: rotate ? 0.3 : 1.0,
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return new Transform(
      alignment: FractionalOffset.center,
      transform: new Matrix4.rotationZ(radians / 12.0),
      child: new Container(
        height: 25.0,
        width: 200.0,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          boxShadow: this.shadows,
          color: this.color,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}

