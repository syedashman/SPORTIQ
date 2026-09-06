import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/features/auth/presentation/screens/account_created_screen.dart';
import 'package:sportiq/features/auth/presentation/screens/choose_sport_screen.dart';
import 'package:sportiq/features/auth/presentation/screens/create_account_options_screen.dart';
import 'package:sportiq/features/auth/presentation/screens/email_signup_screen.dart';
import 'package:sportiq/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:sportiq/features/onboarding/presentation/screens/get_started_screen.dart';
import 'package:sportiq/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:sportiq/features/profile/presentation/screens/complete_profile_screen.dart';
import 'package:sportiq/shared/theme/theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(theme: AppTheme.darkTheme, home: child);
}

void main() {
  testWidgets('WelcomeScreen renders SPORTIQ headline and actions', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const WelcomeScreen()));

    expect(find.textContaining('Welcome to'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });

  testWidgets('GetStartedScreen renders first onboarding page', (tester) async {
    await tester.pumpWidget(_wrap(const GetStartedScreen()));

    expect(find.textContaining('Play Every Match'), findsOneWidget);
    expect(find.text('Skip Introduction'), findsOneWidget);
  });

  testWidgets('CreateAccountOptionsScreen renders Google/Email actions', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const CreateAccountOptionsScreen()));

    expect(find.text('Create Your Identity'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Email'), findsOneWidget);
  });

  testWidgets('EmailSignupScreen renders all required form fields', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const EmailSignupScreen()));

    expect(find.text('Join the Elite'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('VerifyEmailScreen renders verification messaging', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const VerifyEmailScreen()));

    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.text('Resend Email'), findsOneWidget);
  });

  testWidgets('AccountCreatedScreen renders success state', (tester) async {
    await tester.pumpWidget(_wrap(const AccountCreatedScreen()));

    expect(find.text('Welcome to SPORTIQ'), findsOneWidget);
    expect(find.text('Continue to Dashboard'), findsOneWidget);
    expect(find.text('Skip Setup & Browse'), findsOneWidget);
  });

  testWidgets('CompleteProfileScreen renders profile fields and sports', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const CompleteProfileScreen()));

    expect(find.text('Tell Us About You'), findsOneWidget);
    expect(find.text('Display Name'), findsOneWidget);
    expect(find.text('Cricket'), findsNWidgets(2));
    expect(find.text('Football'), findsNWidgets(2));
    expect(find.text('Padel'), findsNWidgets(2));
  });

  testWidgets('ChooseSportScreen renders all three sport cards', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ChooseSportScreen()));

    expect(find.text('What are you playing today?'), findsOneWidget);
    expect(find.text('Cricket'), findsOneWidget);
    expect(find.text('Football'), findsOneWidget);
    expect(find.text('Padel'), findsOneWidget);
    expect(find.text('Choose Later'), findsOneWidget);
  });
}
