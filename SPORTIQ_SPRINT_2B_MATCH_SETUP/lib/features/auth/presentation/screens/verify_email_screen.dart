// Verify Email screen (Stitch ref: email_verification_polished). No real
// email/backend integration yet — Continue simply advances to Account
// Created, and Resend/Change Email are UI-only actions for this batch.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'SPORTIQ',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryFixedDim,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _StepDots(activeStep: 1, totalSteps: 5),
              const Spacer(),
              const Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: AppColors.primaryFixedDim,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Verify your email',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "We've sent a verification link to your email. Open the "
                'email and tap the verification link to activate your '
                'account.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                onPressed: () => context.push('/account-created'),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Resend Email',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email sent')),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Change Email Address'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Didn't receive the email? Check Spam or Promotions.",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.activeStep, required this.totalSteps});

  final int activeStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i <= activeStep;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primaryFixedDim : AppColors.outline,
            ),
          ),
        );
      }),
    );
  }
}
