import 'package:flutter/material.dart';

class PatientProfileAvatar extends StatelessWidget {
  const PatientProfileAvatar({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: size != null ? size! / 2 : null);
  }
}
