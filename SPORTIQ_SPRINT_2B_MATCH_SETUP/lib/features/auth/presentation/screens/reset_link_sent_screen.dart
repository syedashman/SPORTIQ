import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class ResetLinkSentScreen extends StatefulWidget {
  const ResetLinkSentScreen({required this.email, super.key});
  final String email;
  @override
  State<ResetLinkSentScreen> createState() => _ResetLinkSentScreenState();
}

class _ResetLinkSentScreenState extends State<ResetLinkSentScreen> {
  int _cooldown = 0;
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resend() {
    if (_cooldown > 0) return;
    setState(() => _cooldown = 30);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password reset email delivery will become active when authentication integration is connected.',
        ),
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_cooldown <= 1) {
        t.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 76,
                  color: AppColors.primaryFixedDim,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Check Your Email',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.email.isEmpty
                      ? 'Password reset email delivery will become active when authentication integration is connected.'
                      : 'Password reset instructions are prepared for\n${widget.email}\n\nEmail delivery will become active when authentication integration is connected.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Back to Login',
                  onPressed: () => context.go('/login'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: _cooldown == 0 ? _resend : null,
                  child: Text(
                    _cooldown == 0 ? 'Resend Email' : 'Resend in ${_cooldown}s',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
