import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FlagImage extends StatelessWidget {
  const FlagImage({
    super.key,
    required this.code,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: CachedNetworkImage(
          imageUrl:
              'https://flagcdn.com/w40/${code.substring(0, 2).toLowerCase()}.png'),
    );
  }
}
