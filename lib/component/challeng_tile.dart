import 'package:flutter/material.dart';
import 'package:examKing/models/challenge.dart';
import 'package:examKing/styling/clipper.dart';
import 'package:examKing/styling/painters.dart';
import 'package:morphable_shape/morphable_shape.dart';

// NOTE: This would be change to fragment design afterward

class ChallengTile extends StatefulWidget {
  final Challenge challenge;
  final bool isLeft;
  final Function() onPressed;
  const ChallengTile({
    super.key,
    required this.challenge,
    required this.onPressed,
    required this.isLeft,
  });

  @override
  State<ChallengTile> createState() => _ChallengTileState();
}

class _ChallengTileState extends State<ChallengTile> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = widget.isLeft
        ? TriangleShapeBorder(
            point1: const DynamicOffset(Length(0), Length(0)),
            point2: DynamicOffset(Length(MediaQuery.of(context).size.width - 5), Length(200)),
            point3: const DynamicOffset(Length(0), Length(400)),
          )
        : TriangleShapeBorder(
            point1: DynamicOffset(Length(MediaQuery.of(context).size.width), Length(0)),
            point2: const DynamicOffset(Length(5), Length(200)),
            point3: DynamicOffset(Length(MediaQuery.of(context).size.width), Length(400)),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: Material(
        shape: shape,
        clipBehavior: Clip.hardEdge,
        elevation: 20,
        shadowColor: Colors.purple.withOpacity(0.5),
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.challenge.imageURL),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
            gradient: LinearGradient(
              begin: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
              end: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
              colors: [
                Colors.purple.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
          child: InkWell(
            onTap: widget.onPressed,
            splashColor: Colors.purple.withOpacity(0.3),
            highlightColor: Colors.purple.withOpacity(0.1),
            child: CustomPaint(
              foregroundPainter: widget.isLeft ? LeftTrianglePainter(middleHeight: 170) : RightTrianglePainter(middleHeight: 170),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                alignment: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: widget.isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.challenge.name,
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(220, 238, 226, 255),
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "點擊開始",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
