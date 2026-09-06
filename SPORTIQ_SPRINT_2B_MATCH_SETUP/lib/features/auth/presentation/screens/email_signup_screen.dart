// Email Signup screen (Stitch ref: create_account_via_email). Client-side
// form only — no Supabase/backend call yet (see docs/DECISIONS.md: "No
// Supabase integration yet"). On valid submit it simply advances to Verify
// Email, matching the navigation flow for this batch.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  double _passwordStrength = 0;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength(String value) {
    var strength = 0;
    if (value.length > 5) {
      strength++;
    }
    if (value.length > 8 && value.contains(RegExp('[A-Z]'))) {
      strength++;
    }
    if (value.length > 10 && value.contains(RegExp('[0-9]'))) {
      strength++;
    }
    if (value.length > 12 && value.contains(RegExp(r'[^A-Za-z0-9]'))) {
      strength++;
    }
    setState(() => _passwordStrength = strength / 4);
  }

  bool _validate() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _nameError = name.isEmpty ? 'Full name is required' : null;
      _emailError = !email.contains('@') || !email.contains('.')
          ? 'Enter a valid email address'
          : null;
      _passwordError =
          password.length < 6 ? 'Password must be at least 6 characters' : null;
      _confirmPasswordError =
          confirmPassword != password ? 'Passwords do not match' : null;
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  void _submit() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service to continue'),
        ),
      );
      return;
    }
    if (_validate()) {
      context.push('/verify-email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Join the Elite',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Elevate your performance with professional-grade analytics.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              const _FieldLabel('Full Name'),
              AppTextField(
                controller: _nameController,
                hint: 'Your full name',
                errorText: _nameError,
              ),
              const SizedBox(height: AppSpacing.md),
              const _FieldLabel('Email Address'),
              AppTextField(
                controller: _emailController,
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(height: AppSpacing.md),
              const _FieldLabel('Password'),
              AppTextField(
                controller: _passwordController,
                hint: 'Create a password',
                obscureText: _obscurePassword,
                onChanged: _updatePasswordStrength,
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _PasswordStrengthMeter(strength: _passwordStrength),
              const SizedBox(height: AppSpacing.md),
              const _FieldLabel('Confirm Password'),
              AppTextField(
                controller: _confirmPasswordController,
                hint: 'Re-enter your password',
                obscureText: _obscureConfirmPassword,
                errorText: _confirmPasswordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _TermsCheckbox(
                value: _agreedToTerms,
                onChanged: (value) =>
                    setState(() => _agreedToTerms = value ?? false),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Create Account', onPressed: _submit),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.push('/login'),
                child: const Text('Already have an account? Log In'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _PasswordStrengthMeter extends StatelessWidget {
  const _PasswordStrengthMeter({required this.strength});

  final double strength;

  Color _color() {
    if (strength <= 0.25) {
      return AppColors.error;
    }
    if (strength <= 0.5) {
      return AppColors.secondary;
    }
    return AppColors.primaryFixedDim;
  }

  String _label() {
    if (strength <= 0.25) {
      return 'Security Level: Low';
    }
    if (strength <= 0.5) {
      return 'Security Level: Medium';
    }
    if (strength < 1) {
      return 'Security Level: High';
    }
    return 'Security Level: Very High';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.fullRadius,
          child: LinearProgressIndicator(
            value: strength == 0 ? 0.02 : strength,
            minHeight: 4,
            backgroundColor: AppColors.surfaceBright,
            valueColor: AlwaysStoppedAnimation<Color>(_color()),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(_label(), style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(
          child: Text(
            'I agree to the Terms of Service and Privacy Policy.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
