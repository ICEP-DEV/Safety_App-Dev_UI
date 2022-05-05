// import 'package:flutter/material.dart';

// class BubblePainter extends CustomPainter {
//   BubblePainter({
//     required ScrollableState scrollable,
//     required BuildContext bubbleContext,
//     required List<Color> colors,
//   })  : _scrollable = scrollable,
//         _bubbleContext = bubbleContext,
//         _colors = colors;

//   final ScrollableState _scrollable;
//   final BuildContext _bubbleContext;
//   final List<Color> _colors;

//   @override
//   bool shouldRepaint(BubblePainter oldDelegate) {
//     return oldDelegate._scrollable != _scrollable ||
//         oldDelegate._bubbleContext != _bubbleContext ||
//         oldDelegate._colors != _colors;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
//     final scrollableRect = Offset.zero & scrollableBox.size;
//     final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

//     final origin =
//         bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
//     final paint = Paint()
//       ..shader = ui.Gradient.linear(
//         scrollableRect.topCenter,
//         scrollableRect.bottomCenter,
//         _colors,
//         [0.0, 1.0],
//         TileMode.clamp,
//         Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
//       );
//     canvas.drawRect(Offset.zero & size, paint);
//   }
// }

import 'package:flutter/material.dart';

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;

  ChatBubble({
    required this.color,
    required this.alignment,
  });

  var _radius = 10.0;
  var _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 8,
            size.height,
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(size.width - _x, size.height - 90);
      path.lineTo(size.width - _x, size.height + 40);
      path.lineTo(size.width, size.height - 17);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - _x,
            0.0,
            size.width,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(size.width - _x, size.height - 90);
      path.lineTo(size.width - _x, size.height + 40);
      path.lineTo(size.width, size.height - 17);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            _x,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
