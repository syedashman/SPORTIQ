// Standard screen shell: safe-area padded, optional app bar, optional
// sticky bottom action area that never overlaps scrollable content
// (per DESIGN_RULES.md).
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.stickyBottomAction,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? stickyBottomAction;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: stickyBottomAction == null
            ? body
            : Stack(
                children: [
                  Positioned.fill(child: body),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SafeArea(top: false, child: stickyBottomAction!),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
