import 'package:flutter/material.dart';

class RotatingText extends StatefulWidget {

  final List<String> text;
  final TextStyle textStyle;
  final Duration duration;

  const RotatingText({
    Key key,
    this.text,
    this.textStyle,
    this.duration}) : super(key: key);


  @override
  _RotatingTextState createState() => new _RotatingTextState();
}

class _RotatingTextState extends State<RotatingText>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;

  List<Animation<double>> _fadeIn = [];
  List<Animation<double>> _fadeOut = [];
  List<Animation<Alignment>> _slideIn = [];
  List<Animation<Alignment>> _slideOut = [];

  List<Widget> textWidgetList = [];

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..repeat();

    int lengthList = widget.text.length;

    double percentTime = 1.0 / lengthList;
    double fadeTime = 1.0 / (lengthList * 7);
    double slideTime = 1.0 / (lengthList * 5);

    for (int i = 0; i < widget.text.length; i++) {
      if (i == 0) {
        _fadeOut.add(
            Tween<double>(begin: 1.0, end: 0.0)
                .animate(
                CurvedAnimation(parent: _controller,
                    curve: Interval((percentTime - fadeTime), percentTime,
                        curve: Curves.easeIn))
            )
        );
        _slideOut.add(
            new AlignmentTween(
                begin: new Alignment(-1.0, 0.0), end: new Alignment(-1.0, 1.0))
                .animate(
                CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                        (percentTime - slideTime), percentTime,
                        curve: Curves.easeIn)))
              ..addListener(() => setState(() => {})
              )
        );
      }
      else if (i < widget.text.length - 1) {
        _slideIn.add(
            AlignmentTween(
              begin: Alignment(-1.0, -1.0), end: new Alignment(-1.0, 0.0),
            ).animate(
                CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                        (i * percentTime) - slideTime,
                        (i) * percentTime,
                        curve: Curves.easeIn)
                )
            )
              ..addListener(() => setState(() => {}))
        );
        _fadeIn.add(
            Tween<double>(begin: 0.0, end: 1.0)
                .animate(
                CurvedAnimation(parent: _controller,
                    curve: Interval(
                        (i * percentTime) - slideTime,
                        (i * percentTime) - slideTime + fadeTime,
                        curve: Curves.easeOut
                    )
                )
            )
        );
        _slideOut.add(
            AlignmentTween(
              begin: Alignment(-1.0, 0.0), end: new Alignment(-1.0, 1.0),
            ).animate(
                CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                        ((i + 1) * percentTime) - slideTime,
                        (i + 1) * percentTime,
                        curve: Curves.easeIn)
                )
            )
              ..addListener(() => setState(() => {}))
        );
        _fadeOut.add(
            Tween<double>(begin: 1.0, end: 0.0)
                .animate(
                CurvedAnimation(parent: _controller,
                    curve: Interval(
                        ((i + 1) * percentTime) - slideTime,
                        ((i + 1) * percentTime) - slideTime + fadeTime,
                        curve: Curves.easeIn
                    )
                )
            )
        );
      }
      else {
        _slideIn.add(
            AlignmentTween(
              begin: Alignment(-1.0, -1.0), end: new Alignment(-1.0, 0.0),
            ).animate(
                CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                        (i * percentTime) - slideTime,
                        (i) * percentTime,
                        curve: Curves.easeIn)
                )
            )
              ..addListener(() => setState(() => {}))
        );
        _fadeIn.add(
            Tween<double>(begin: 0.0, end: 1.0)
                .animate(
                CurvedAnimation(parent: _controller,
                    curve: Interval(
                        (i * percentTime) - slideTime,
                        (i * percentTime) - slideTime + fadeTime,
                        curve: Curves.easeOut
                    )
                )
            )
        );
      }
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.text.length; i++) {
      if (i == 0) {

      }
      else if (i < widget.text.length - 1) {

      }
      else {

      }

      textWidgetList.add(
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return SizedBox(
                height: 40.0,
                child: AlignTransition(
                  alignment: !(_slideIn[i].value.y == 0.0)
                      ? _slideIn[i]
                      : _slideOut[i],
                  child: Text(
                    widget.text[i],
                    style: widget.textStyle,
                  ),
                ),
              );
            },
          )
      );
    }

    return Stack(
      children: textWidgetList,
    );
  }
}
