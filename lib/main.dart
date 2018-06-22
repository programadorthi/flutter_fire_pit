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
  AnimationController _growUpFlameController;
  AnimationController _leftDismissFlameController;
  AnimationController _rightDismissFlameController;
  AnimationController _leftBackFlameController;
  AnimationController _rightBackFlameController;

  Animation<Color> _colorTween;

  @override
  void initState() {
    super.initState();

    _leftDismissFlameController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    );

    _rightDismissFlameController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    );

    _leftBackFlameController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _leftBackFlameController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _leftDismissFlameController.forward(from: 0.0);
        }
      });

    _rightBackFlameController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _rightBackFlameController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _rightDismissFlameController.forward(from: 0.0);
        }
      });

    _growUpFlameController = new AnimationController(
      duration: new Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rightBackFlameController.forward();
        _growUpFlameController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _leftBackFlameController.forward();
        _growUpFlameController.forward();
      }
    });

    _colorTween = ColorTween(
      begin: new Color(0xFFFDBB01),
      end: new Color(0xFFF78801),
    ).animate(_growUpFlameController);

    _growUpFlameController.forward();
  }

  @override
  void dispose() {
    _growUpFlameController.dispose();
    _leftDismissFlameController.dispose();
    _rightDismissFlameController.dispose();
    _leftBackFlameController.dispose();
    _rightBackFlameController.dispose();
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
              new Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  new DismissFlameWidget(
                    animation: _leftDismissFlameController,
                    isLeft: true,
                  ),
                  new DismissFlameWidget(
                    animation: _rightDismissFlameController,
                    isLeft: false,
                  ),
                  new BackFlameWidget(
                    animation: _leftBackFlameController,
                    isLeft: true,
                  ),
                  new BackFlameWidget(
                    animation: _rightBackFlameController,
                    isLeft: false,
                  ),
                  new GrowUpFlameWidget(
                    animation: _growUpFlameController,
                    colorAnimation: _colorTween,
                    isLeft: true,
                  ),
                  new GrowUpFlameWidget(
                    animation: _growUpFlameController,
                    colorAnimation: _colorTween,
                    isLeft: false,
                  ),
                ],
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

class GrowUpFlameWidget extends StatelessWidget {
  final bool isLeft;
  final Animation<double> animation;
  final Animation<Color> colorAnimation;

  GrowUpFlameWidget({this.isLeft, this.animation, this.colorAnimation});

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget widget) {
        if (this.isLeft && this.animation.status == AnimationStatus.reverse) {
          return new FlameWidget(
            color: this.colorAnimation.value,
            rotateZ: math.pi / 4.0,
            size: 100.0 * (1.0 - this.animation.value),
            translateX: -25.0 * (1.0 - this.animation.value),
            translateY: 0.0,
          );
        }
        if (!this.isLeft && this.animation.status == AnimationStatus.forward) {
          return new FlameWidget(
            color: this.colorAnimation.value,
            rotateZ: math.pi / 4.0,
            size: 100.0 * this.animation.value,
            translateX: 25.0 * this.animation.value,
            translateY: 0.0,
          );
        }
        return new Container();
      },
    );
  }
}

class BackFlameWidget extends StatelessWidget {
  final double rotateZ;
  final double translateX;
  final Animation<double> animation;

  BackFlameWidget({bool isLeft = false, this.animation})
      : rotateZ = isLeft ? -math.pi : math.pi,
        translateX = isLeft ? -25.0 : 25.0;

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget widget) {
        return new FlameWidget(
          color: new Color(0xFFF36B01),
          rotateZ: this.rotateZ / (4.0 - animation.value),
          size: 100.0,
          translateX: this.translateX,
          translateY: 0.0,
        );
      },
    );
  }
}

class DismissFlameWidget extends StatelessWidget {
  final double translateX;
  final Animation<double> animation;

  DismissFlameWidget({bool isLeft = false, this.animation})
      : translateX = isLeft ? -25.0 : 25.0;

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget widget) {
        if (animation.isCompleted) {
          return new Container();
        }
        return new FlameWidget(
          color: new Color(0xFFF36B01),
          rotateZ: math.pi / 4.0,
          size: 100.0 * (1.0 - animation.value),
          translateX: this.translateX * (1.0 - animation.value),
          translateY: -270.0 * animation.value,
        );
      },
    );
  }
}

class FlameWidget extends StatelessWidget {
  final Color color;
  final double rotateZ;
  final double size;
  final double translateX;
  final double translateY;

  FlameWidget({
    this.color,
    this.rotateZ,
    this.size,
    this.translateX,
    this.translateY,
  });

  @override
  Widget build(BuildContext context) {
    return new Transform(
      alignment: FractionalOffset.center,
      transform: new Matrix4.translationValues(
        this.translateX,
        this.translateY,
        0.0,
      )..rotateZ(this.rotateZ),
      child: new Container(
        height: this.size,
        width: this.size,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: this.color,
          shape: BoxShape.rectangle,
        ),
      ),
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
