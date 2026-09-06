import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;

  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _heroScale;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _ambientController = AnimationController(
      duration: const Duration(milliseconds: 4200),
      vsync: this,
    );

    _contentOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _heroScale = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _entranceController.forward();
    _ambientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _LuxuryBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 720;

                return FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        isCompact ? AppSpacing.md : AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          const _TopBar(),
                          SizedBox(
                            height: isCompact ? AppSpacing.md : AppSpacing.xl,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight -
                                      (isCompact ? 180 : 150),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'PLAY. TRACK. GROW.',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color:
                                                    AppColors.primaryFixedDim,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 2.6,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        Text.rich(
                                          TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.02,
                                                  letterSpacing: -1.4,
                                                ),
                                            children: const [
                                              TextSpan(text: 'Welcome to\n'),
                                              TextSpan(
                                                text: 'SPORTIQ',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.primaryFixedDim,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 390,
                                          ),
                                          child: Text(
                                            'The smarter way to play, score, '
                                            'track and relive every match.',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: AppColors
                                                      .onSurfaceVariant,
                                                  height: 1.55,
                                                ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: isCompact
                                              ? AppSpacing.lg
                                              : AppSpacing.xxl,
                                        ),
                                        ScaleTransition(
                                          scale: _heroScale,
                                          child: _PremiumSportsHero(
                                            controller: _ambientController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.xxl,
                                      ),
                                      child: Column(
                                        children: [
                                          PrimaryButton(
                                            label: 'Get Started',
                                            icon: Icons.arrow_forward_rounded,
                                            onPressed: () =>
                                                context.push('/get-started'),
                                          ),
                                          const SizedBox(height: AppSpacing.sm),
                                          SecondaryButton(
                                            label: 'I already have an account',
                                            onPressed: () =>
                                                context.push('/login'),
                                          ),
                                          const SizedBox(height: AppSpacing.md),
                                          Text(
                                            'Cricket • Football • Padel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: AppColors.outline,
                                                  letterSpacing: 0.8,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _SportiqWordmark(),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised.withValues(alpha: 0.72),
            borderRadius: AppRadius.fullRadius,
            border: Border.all(color: AppColors.glassStroke),
          ),
          child: IconButton(
            tooltip: 'Help',
            icon: const Icon(Icons.help_outline_rounded),
            color: AppColors.onSurfaceVariant,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help center coming soon')),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SportiqWordmark extends StatelessWidget {
  const _SportiqWordmark();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.skewX(-0.12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            'SPORTIQ',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.22),
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  letterSpacing: -1.8,
                  height: 1,
                ),
          ),
          Positioned(
            left: -1,
            top: -1,
            child: Text(
              'SPORTIQ',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primaryFixedDim,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: -1.8,
                height: 1,
                shadows: [
                  Shadow(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.42),
                    blurRadius: 16,
                  ),
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 2,
            right: 5,
            bottom: -7,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryFixedDim,
                    AppColors.primaryFixedDim.withValues(alpha: 0.08),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumSportsHero extends StatelessWidget {
  const _PremiumSportsHero({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.32,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final glow = 0.82 + (controller.value * 0.18);

          return Transform.scale(scale: glow, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdRadius,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF182414), Color(0xFF101710), Color(0xFF0A0E0A)],
            ),
            border: Border.all(
              color: AppColors.primaryFixedDim.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.12),
                blurRadius: 38,
                spreadRadius: -12,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.mdRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CustomPaint(painter: _ArenaPainter()),
                Positioned(
                  top: -52,
                  right: -44,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryFixedDim.withValues(alpha: 0.22),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  right: 22,
                  top: 22,
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryFixedDim,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LIVE MATCH ECOSYSTEM',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primaryFixedDim,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.4,
                                ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, 12),
                    child: const _SportsEmblem(),
                  ),
                ),
                const Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricChip(value: '03', label: 'SPORTS'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _MetricChip(value: 'LIVE', label: 'SCORING'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _MetricChip(value: '∞', label: 'MATCHES'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SportsEmblem extends StatelessWidget {
  const _SportsEmblem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
                  blurRadius: 28,
                ),
              ],
            ),
          ),
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixedDim.withValues(alpha: 0.11),
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.45),
              ),
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: AppColors.primaryFixedDim,
              size: 38,
            ),
          ),
          const Positioned(
            left: 0,
            top: 58,
            child: _SportOrb(icon: Icons.sports_cricket_rounded),
          ),
          const Positioned(
            right: 0,
            top: 58,
            child: _SportOrb(icon: Icons.sports_soccer_rounded),
          ),
          const Positioned(
            top: 0,
            child: _SportOrb(icon: Icons.sports_tennis_rounded),
          ),
        ],
      ),
    );
  }
}

class _SportOrb extends StatelessWidget {
  const _SportOrb({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.glassStroke),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.36),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, size: 23, color: AppColors.onBackground),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceBase.withValues(alpha: 0.72),
        borderRadius: AppRadius.smRadius,
        border: Border.all(color: AppColors.glassStroke),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 9,
                  letterSpacing: 0.8,
                ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryBackground extends StatelessWidget {
  const _LuxuryBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0C1609), Color(0xFF0A1008), Color(0xFF080C08)],
        ),
      ),
      child: CustomPaint(painter: _BackgroundGridPainter()),
    );
  }
}

class _BackgroundGridPainter extends CustomPainter {
  const _BackgroundGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.018)
      ..strokeWidth = 1;

    const gap = 42.0;

    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryFixedDim.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.42),
          radius: math.max(size.width, size.height) * 0.44,
        ),
      );

    canvas.drawRect(Offset.zero & size, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ArenaPainter extends CustomPainter {
  const _ArenaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final accentPaint = Paint()
      ..color = AppColors.primaryFixedDim.withValues(alpha: 0.09)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.92,
        height: size.height * 0.54,
      ),
      linePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.64,
        height: size.height * 0.36,
      ),
      accentPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.5),
      Offset(size.width * 0.92, size.height * 0.5),
      linePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.5, size.height * 0.9),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
