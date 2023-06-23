import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme(
    this.name, {
    required this.primary,
    required this.secondary,
  });
  final String name;
  final Color primary;
  final Color secondary;
}

const appThemes = [
  AppTheme(
    "White Theme",
    primary: Colors.white,
    secondary: Colors.black,
  ),
  AppTheme(
    "Brown Theme",
    primary: Color(0xFFEFEBE9), // brown50
    secondary: Color(0xFF6D4C41), // brown600
  ),
];
