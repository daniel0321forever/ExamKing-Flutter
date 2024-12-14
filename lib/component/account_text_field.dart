import 'package:flutter/material.dart';

class AccountTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? errorText;
  const AccountTextField({super.key, required this.controller, required this.labelText, required this.prefixIcon, required this.obscureText, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
          errorText: errorText,
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          prefixIcon: Icon(prefixIcon, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black26, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black26, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
