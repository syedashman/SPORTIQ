import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.metricValue,
    required this.metricLabel,
    required this.secondaryIcon,
  });

  final IconData icon;
  final IconData secondaryIcon;
  final String eyebrow;
  final String title;
  final String description;
  final String metricValue;
  final String metricLabel;
}

const List<_OnboardingPage> _pages = [
  _OnboardingPage(
    icon: Icons.sports_cricket_rounded,
    secondaryIcon: Icons.sports_soccer_rounded,
    eyebrow: 'SMART MATCH EXPERIENCE',
    title: 'Play Every Match\nSmarter',
    description:
        'Track scores, match events and player performance while you stay '
        'focused on the game.',
    metricValue: 'LIVE',
    metricLabel: 'SCORING',
  ),
  _OnboardingPage(
    icon: Icons.insights_rounded,
    secondaryIcon: Icons.person_rounded,
    eyebrow: 'YOUR SPORTS IDENTITY',
    title: 'Turn Performance\nInto Progress',
    description:
        'Build a complete player profile with match history, achievements '
        'and meaningful performance insights.',
    metricValue: '360°',
    metricLabel: 'PROFILE',
  ),
  _OnboardingPage(
    icon: Icons.emoji_events_rounded,
    secondaryIcon: Icons.groups_rounded,
    eyebrow: 'COMPETE TOGETHER',
    title: 'Create Teams.\nRun Tournaments.',
    description:
        'Organize players, fixtures and competitions from friendly matches '
        'to full-scale tournaments.',
    metricValue: 'PRO',
    metricLabel: 'CONTROL',
  ),
];

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _controller = PageController();

  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _pages.length - 1) {
      context.push('/signup');
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _skip() {
    context.push('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _index == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _OnboardingBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 720;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        isCompact ? AppSpacing.sm : AppSpacing.md,
                        AppSpacing.lg,
                        0,
                      ),
                      child: const _TopBar(),
                    ),
                    SizedBox(height: isCompact ? AppSpacing.sm : AppSpacing.md),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _pages.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (value) {
                          setState(() {
                            _index = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              var pageValue = 0.0;

                              if (_controller.hasClients &&
                                  _controller.position.haveDimensions) {
                                pageValue =
                                    (_controller.page ?? _index.toDouble()) -
                                        index;
                              }

                              final distance = pageValue.abs().clamp(0.0, 1.0);
                              final scale = 1 - (distance * 0.06);
                              final opacity = 1 - (distance * 0.28);

                              return Transform.scale(
                                scale: scale,
                                child: Opacity(opacity: opacity, child: child),
                              );
                            },
                            child: _OnboardingPageView(
                              page: _pages[index],
                              pageIndex: index,
                              isCompact: isCompact,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        isCompact ? AppSpacing.md : AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          _PageIndicator(
                            count: _pages.length,
                            activeIndex: _index,
                          ),
                          SizedBox(
                            height: isCompact ? AppSpacing.md : AppSpacing.lg,
                          ),
                          PrimaryButton(
                            label: isLastPage ? 'Start Your Journey' : 'Next',
                            icon: isLastPage
                                ? Icons.arrow_forward_rounded
                                : Icons.chevron_right_rounded,
                            onPressed: _next,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SecondaryButton(
                            label: 'Skip Introduction',
                            onPressed: _skip,
                          ),
                        ],
                      ),
                    ),
                  ],
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _SportiqWordmark(),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceRaised.withValues(alpha: 0.72),
            border: Border.all(color: AppColors.glassStroke),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: 'Close introduction',
            onPressed: () => context.go('/welcome'),
            icon: const Icon(
              Icons.close_rounded,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
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
      transform: Matrix4.skewX(-0.1),
      child: Text(
        'SPORTIQ',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.primaryFixedDim,
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: -1.2,
          height: 1,
          shadows: [
            Shadow(
              color: AppColors.primaryFixedDim.withValues(alpha: 0.3),
              blurRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({
    required this.page,
    required this.pageIndex,
    required this.isCompact,
  });

  final _OnboardingPage page;
  final int pageIndex;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: isCompact ? 470 : 550),
          child: Column(
            children: [
              SizedBox(height: isCompact ? AppSpacing.sm : AppSpacing.lg),
              Text(
                page.eyebrow,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryFixedDim,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.1,
                      fontSize: 10,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w900,
                      fontSize: isCompact ? 29 : 34,
                      height: 1.04,
                      letterSpacing: -1.4,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.55,
                        fontSize: 15,
                      ),
                ),
              ),
              SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xxl),
              _PremiumFeatureVisual(
                page: page,
                pageIndex: pageIndex,
                isCompact: isCompact,
              ),
              SizedBox(height: isCompact ? AppSpacing.md : AppSpacing.lg),
              _FeatureBenefits(pageIndex: pageIndex),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumFeatureVisual extends StatelessWidget {
  const _PremiumFeatureVisual({
    required this.page,
    required this.pageIndex,
    required this.isCompact,
  });

  final _OnboardingPage page;
  final int pageIndex;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final visualHeight = isCompact ? 205.0 : 235.0;

    return Container(
      height: visualHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF172313), Color(0xFF10170E), Color(0xFF090D09)],
        ),
        border: Border.all(
          color: AppColors.primaryFixedDim.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryFixedDim.withValues(alpha: 0.11),
            blurRadius: 34,
            spreadRadius: -10,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.mdRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _FeatureVisualPainter(pageIndex: pageIndex)),
            Positioned(
              top: -50,
              right: -42,
              child: Container(
                width: 165,
                height: 165,
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
              left: 18,
              top: 17,
              child: _LiveStatusBadge(pageIndex: pageIndex),
            ),
            Center(
              child: _FeatureEmblem(page: page, pageIndex: pageIndex),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Row(
                children: [
                  Expanded(
                    child: _VisualMetric(
                      value: page.metricValue,
                      label: page.metricLabel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _VisualMetric(
                      value: _secondaryMetricValue(pageIndex),
                      label: _secondaryMetricLabel(pageIndex),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _VisualMetric(
                      value: _thirdMetricValue(pageIndex),
                      label: _thirdMetricLabel(pageIndex),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _secondaryMetricValue(int index) {
    switch (index) {
      case 0:
        return 'AUTO';
      case 1:
        return 'SMART';
      default:
        return 'TEAM';
    }
  }

  String _secondaryMetricLabel(int index) {
    switch (index) {
      case 0:
        return 'TRACKING';
      case 1:
        return 'INSIGHTS';
      default:
        return 'SETUP';
    }
  }

  String _thirdMetricValue(int index) {
    switch (index) {
      case 0:
        return 'FAST';
      case 1:
        return 'GROW';
      default:
        return 'LIVE';
    }
  }

  String _thirdMetricLabel(int index) {
    switch (index) {
      case 0:
        return 'UPDATES';
      case 1:
        return 'BETTER';
      default:
        return 'EVENTS';
    }
  }
}

class _FeatureEmblem extends StatelessWidget {
  const _FeatureEmblem({required this.page, required this.pageIndex});

  final _OnboardingPage page;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.18),
              ),
            ),
          ),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryFixedDim.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.48),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.18),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Icon(page.icon, size: 43, color: AppColors.primaryFixedDim),
          ),
          Positioned(
            left: 8,
            bottom: 20,
            child: _FloatingIcon(icon: page.secondaryIcon),
          ),
          Positioned(
            right: 8,
            top: 22,
            child: _FloatingIcon(icon: _supportingIcon(pageIndex)),
          ),
        ],
      ),
    );
  }

  IconData _supportingIcon(int index) {
    switch (index) {
      case 0:
        return Icons.scoreboard_rounded;
      case 1:
        return Icons.trending_up_rounded;
      default:
        return Icons.calendar_month_rounded;
    }
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({required this.icon});

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
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.onBackground, size: 23),
    );
  }
}

class _LiveStatusBadge extends StatelessWidget {
  const _LiveStatusBadge({required this.pageIndex});

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
        borderRadius: AppRadius.fullRadius,
        border: Border.all(
          color: AppColors.primaryFixedDim.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixedDim,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            _label(pageIndex),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  fontSize: 9,
                ),
          ),
        ],
      ),
    );
  }

  String _label(int index) {
    switch (index) {
      case 0:
        return 'MATCH READY';
      case 1:
        return 'PROFILE ACTIVE';
      default:
        return 'TOURNAMENT MODE';
    }
  }
}

class _VisualMetric extends StatelessWidget {
  const _VisualMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceBase.withValues(alpha: 0.8),
        borderRadius: AppRadius.smRadius,
        border: Border.all(color: AppColors.glassStroke),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryFixedDim,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
            ),
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureBenefits extends StatelessWidget {
  const _FeatureBenefits({required this.pageIndex});

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final benefits = _benefitsFor(pageIndex);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: benefits
          .map(
            (benefit) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised.withValues(alpha: 0.56),
                borderRadius: AppRadius.fullRadius,
                border: Border.all(color: AppColors.glassStroke),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.primaryFixedDim,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    benefit,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  List<String> _benefitsFor(int index) {
    switch (index) {
      case 0:
        return ['Live scoring', 'Match events', 'Instant results'];
      case 1:
        return ['Player stats', 'Match history', 'Achievements'];
      default:
        return ['Team management', 'Fixtures', 'Standings'];
    }
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 28 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryFixedDim
                : AppColors.outline.withValues(alpha: 0.5),
            borderRadius: AppRadius.fullRadius,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryFixedDim.withValues(alpha: 0.28),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D170A), Color(0xFF0A1008), Color(0xFF070B07)],
        ),
      ),
      child: CustomPaint(painter: _BackgroundPainter()),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.016)
      ..strokeWidth = 1;

    const spacing = 44.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryFixedDim.withValues(alpha: 0.075),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.52, size.height * 0.42),
          radius: math.max(size.width, size.height) * 0.42,
        ),
      );

    canvas.drawRect(Offset.zero & size, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _FeatureVisualPainter extends CustomPainter {
  const _FeatureVisualPainter({required this.pageIndex});

  final int pageIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final greenPaint = Paint()
      ..color = AppColors.primaryFixedDim.withValues(alpha: 0.09)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height * 0.5);

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.84,
        height: size.height * 0.52,
      ),
      whitePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.58,
        height: size.height * 0.34,
      ),
      greenPaint,
    );

    if (pageIndex == 0) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.5),
        Offset(size.width * 0.9, size.height * 0.5),
        whitePaint,
      );
    } else if (pageIndex == 1) {
      final path = Path()
        ..moveTo(size.width * 0.12, size.height * 0.7)
        ..lineTo(size.width * 0.3, size.height * 0.58)
        ..lineTo(size.width * 0.48, size.height * 0.63)
        ..lineTo(size.width * 0.68, size.height * 0.38)
        ..lineTo(size.width * 0.88, size.height * 0.26);

      canvas.drawPath(path, greenPaint);
    } else {
      canvas.drawCircle(center, size.height * 0.28, greenPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FeatureVisualPainter oldDelegate) {
    return oldDelegate.pageIndex != pageIndex;
  }
}
