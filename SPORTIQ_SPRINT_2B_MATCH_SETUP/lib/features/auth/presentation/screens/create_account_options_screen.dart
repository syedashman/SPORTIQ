// Create Account Options screen (Stitch ref: create_account_options).
// No Supabase/auth integration yet — "Continue with Google" is a UI
// placeholder (shows a snackbar) until backend auth lands in a later
// sprint. Only "Continue with Email" is a real navigation action.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';

class CreateAccountOptionsScreen extends StatelessWidget {
  const CreateAccountOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Create Your Identity',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Join the elite ranks of professional athletes and '
                'high-stakes enthusiasts.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SecondaryButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Google sign-in will be activated when OAuth configuration is connected.',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Continue with Email',
                icon: Icons.mail_outline,
                onPressed: () => context.push('/signup/email'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.push('/login'),
                child: const Text('Already have an account? Log In'),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Text(
                  'By continuing, you agree to our Terms and Privacy Policy.',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
