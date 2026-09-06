// Account Created success screen (Stitch ref: account_created_success).
// "Continue to Dashboard" routes to Complete Profile for now, since
// Dashboard itself is out of scope for this batch (first-time users
// complete their profile before landing on the real Dashboard in a later
// sprint). "Skip Setup" goes straight to the existing Dashboard route
// placeholder.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/surfaces/app_badge.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceRaised,
                  border: Border.fromBorderSide(
                    BorderSide(color: AppColors.primaryFixedDim, width: 2),
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: AppColors.primaryFixedDim,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Welcome to SPORTIQ',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your sports journey starts now. Your profile is ready for '
                'peak performance.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBadge(
                    label: 'Pro Status Active',
                    variant: AppBadgeVariant.success,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  AppBadge(label: 'ID Verified', variant: AppBadgeVariant.info),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Continue to Dashboard',
                icon: Icons.arrow_forward,
                onPressed: () => context.push('/profile/complete'),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Skip Setup & Browse',
                onPressed: () => context.push('/dashboard'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
