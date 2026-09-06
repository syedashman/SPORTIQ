// Standard circular avatar with fallback initials.
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({this.imageUrl, this.initials, this.size = 40, super.key});

  final String? imageUrl;
  final String? initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.surfaceBright,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(initials ?? '?', style: Theme.of(context).textTheme.labelLarge)
          : null,
    );
  }
}
