import 'package:flutter/material.dart';
import 'dart:ui';


class CustomSnackBar {
  final String message;

  const CustomSnackBar({required this.message});

  SnackBar get snackbar {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 198, 198, 198),
          border: Border.all(
              color: const Color.fromARGB(255, 46, 46, 46), width: 0.2),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Color.fromARGB(172, 46, 44, 44),
          //     spreadRadius: 1.0,
          //     blurRadius: 5.0,
          //     offset: Offset(2, 4),
          //   ),
          // ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
