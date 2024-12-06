import 'dart:ui';

import 'package:flutter/material.dart';

class BattleAvatar extends StatefulWidget {
  final ImageProvider image;
  const BattleAvatar({super.key, required this.image});

  @override
  State<BattleAvatar> createState() => _BattleAvatarState();
}

class _BattleAvatarState extends State<BattleAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.softLight,
            ),
            child: Image(
              image: widget.image,
              fit: BoxFit.cover,
              height: 90,
              width: 90,
            ),
          ),
        ),
      ),
    );
  }
}
