import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final Function() onTap;
  const CancelButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(width: 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text("Cancel"),
      ),
    );
  }
}
