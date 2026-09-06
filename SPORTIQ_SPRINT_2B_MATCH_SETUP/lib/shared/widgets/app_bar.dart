// Centralized top app bar, styled via AppBarTheme — never override colors
// or text styles inline.
import 'package:flutter/material.dart';

class SportiqAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SportiqAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
