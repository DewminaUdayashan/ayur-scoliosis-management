import 'package:flutter/widgets.dart';

class Page {
  Page({
    required this.id,
    required this.label,
    required this.icon,
    required this.page,
  });
  final int id;
  final String label;
  final IconData icon;
  final Widget page;
}
