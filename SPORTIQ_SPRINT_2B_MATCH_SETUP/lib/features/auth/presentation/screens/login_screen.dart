import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError, _passwordError;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validEmail(String value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  void _handleLogin() {
    final email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? 'Email is required'
          : (!_validEmail(email) ? 'Enter a valid email address' : null);
      _passwordError = _password.text.isEmpty ? 'Password is required' : null;
    });
    if (_emailError == null && _passwordError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email login will be activated when authentication integration is connected.',
          ),
        ),
      );
    }
  }

  void _handleGoogleSignIn() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Google sign-in will be activated when OAuth configuration is connected.',
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/welcome'),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'SPORTIQ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryFixedDim,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Log in to continue tracking every match.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  key: const Key('login_email'),
                  controller: _email,
                  label: 'Email Address',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  key: const Key('login_password'),
                  controller: _password,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: _obscure,
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    key: const Key('password_visibility'),
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(label: 'Log In', onPressed: _handleLogin),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        'or',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SecondaryButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata,
                  onPressed: _handleGoogleSignIn,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: const Text('Create Account'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      );
}
