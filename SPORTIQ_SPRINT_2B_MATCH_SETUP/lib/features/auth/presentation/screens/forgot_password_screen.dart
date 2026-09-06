import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  String? _error;
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  bool _valid(String v) => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
  void _submit() {
    final e = _email.text.trim();
    setState(
      () => _error = e.isEmpty
          ? 'Email is required'
          : (!_valid(e) ? 'Enter a valid email address' : null),
    );
    if (_error == null) context.push('/reset-link-sent', extra: e);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/login'),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 64,
                  color: AppColors.primaryFixedDim,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Enter your email and we’ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  key: const Key('forgot_email'),
                  controller: _email,
                  label: 'Email Address',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _error,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(label: 'Send Reset Link', onPressed: _submit),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      );
}
