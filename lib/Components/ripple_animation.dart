import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:why_taxi_driver/Locale/locale.dart';
import 'package:why_taxi_driver/Locale/strings_enum.dart';
import 'package:why_taxi_driver/utils/Session.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({
    Key? key,
    this.size = 80.0,
    this.color = Colors.red,
    this.onPressed,
    this.child,
  }) : super(key: key);
  final double size;
  final Color color;
  final Widget? child;
  final VoidCallback? onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .04)!
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller!,
                  curve: const CurveWave(),
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 50,
                child: Text(
                  getTranslated(context,Strings.GO)! + '\n' + getTranslated(context,Strings.ONLINE)!,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: CirclePainter(
          _controller,
          color: widget.color,
        ),
        child: SizedBox(
          width: widget.size * 4.125,
          height: widget.size * 4.125,
          child: _button(),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final Animation<double>? _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 7;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 2);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation!.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
