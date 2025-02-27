import 'package:flutter/cupertino.dart';

class RoundedRectTabIndicator extends Decoration {
  final BoxPainter _painter;

  RoundedRectTabIndicator(
      {required Color color, required double radius, required Color borderColor, required double borderWidth})
      : _painter = _RoundedRectPainter(color, radius, borderColor, borderWidth);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _RoundedRectPainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  final Paint _borderPaint;

  _RoundedRectPainter(Color color, this.radius, Color borderColor, double borderWidth)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true,
        _borderPaint = Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final RRect rRect = RRect.fromRectAndRadius(
      offset & cfg.size!,
      Radius.circular(radius),
    );

    canvas.drawRRect(rRect, _paint); // Dessine l'indicateur
    canvas.drawRRect(rRect, _borderPaint); // Dessine la bordure
  }
}
