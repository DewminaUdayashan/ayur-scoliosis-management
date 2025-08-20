import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientProfileAvatar extends StatelessWidget {
  const PatientProfileAvatar({super.key, this.size, required this.url});
  final double? size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size != null ? size! / 2 : null,
      backgroundImage: url != null ? CachedNetworkImageProvider(url!) : null,
      child: url == null
          ? const Icon(CupertinoIcons.person_fill, size: 40)
          : null,
    );
  }
}
