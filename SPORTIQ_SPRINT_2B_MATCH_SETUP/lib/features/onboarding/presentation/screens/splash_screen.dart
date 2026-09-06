import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _glowController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoPosition;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglinePosition;
  late final Animation<double> _lineWidth;
  late final Animation<double> _glowScale;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    );

    final logoCurve = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0, 0.65, curve: Curves.easeOutCubic),
    );

    final taglineCurve = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.45, 1, curve: Curves.easeOutCubic),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(logoCurve);

    _logoScale = Tween<double>(begin: 0.92, end: 1).animate(logoCurve);

    _logoPosition = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(logoCurve);

    _taglineOpacity = Tween<double>(begin: 0, end: 0.68).animate(taglineCurve);

    _taglinePosition = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(taglineCurve);

    _lineWidth = Tween<double>(begin: 0, end: 140).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _glowScale = Tween<double>(begin: 0.88, end: 1.1).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _entranceController.forward();
    _glowController.repeat(reverse: true);

    _navigationTimer = Timer(
      const Duration(milliseconds: 3200),
      _openWelcomeScreen,
    );
  }

  void _openWelcomeScreen() {
    if (!mounted) {
      return;
    }

    context.go('/welcome');
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _SplashBackground(),
          _buildAnimatedGlow(),
          _buildBranding(context),
          const _CornerDecoration(alignment: Alignment.topLeft, reverse: false),
          const _CornerDecoration(
            alignment: Alignment.bottomRight,
            reverse: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedGlow() {
    return Center(
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Transform.scale(scale: _glowScale.value, child: child);
        },
        child: Container(
          width: 360,
          height: 360,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryFixedDim.withValues(alpha: 0.22),
                AppColors.primaryFixedDim.withValues(alpha: 0.08),
                Colors.transparent,
              ],
              stops: const [0, 0.38, 1],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoSize = screenWidth < 380 ? 38.0 : 44.0;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedBuilder(
            animation: _entranceController,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: SlideTransition(
                      position: _logoPosition,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Text(
                          'SPORTIQ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryFixedDim,
                            fontSize: logoSize,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -1.8,
                            height: 1,
                            shadows: [
                              Shadow(
                                color: AppColors.primaryFixedDim.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: _lineWidth.value,
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryFixedDim,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: SlideTransition(
                      position: _taglinePosition,
                      child: const Text(
                        'E V E R Y   M A T C H   M A T T E R S .',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF090B09),
            AppColors.background,
            Color(0xFF081007),
            Color(0xFF090B09),
          ],
          stops: [0, 0.34, 0.68, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -180,
            left: -120,
            child: _AtmosphericLight(
              size: 420,
              color: Colors.white,
              opacity: 0.025,
            ),
          ),
          Positioned(
            right: -180,
            bottom: 60,
            child: _AtmosphericLight(
              size: 500,
              color: AppColors.primaryFixedDim,
              opacity: 0.05,
            ),
          ),
          CustomPaint(painter: _TechnicalBackgroundPainter()),
        ],
      ),
    );
  }
}

class _AtmosphericLight extends StatelessWidget {
  const _AtmosphericLight({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _CornerDecoration extends StatelessWidget {
  const _CornerDecoration({required this.alignment, required this.reverse});

  final Alignment alignment;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Opacity(
            opacity: 0.28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  width: reverse ? 18 : 34,
                  height: 1,
                  color: AppColors.primaryFixedDim,
                ),
                const SizedBox(height: 6),
                Container(
                  width: reverse ? 34 : 18,
                  height: 1,
                  color: AppColors.primaryFixedDim,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TechnicalBackgroundPainter extends CustomPainter {
  const _TechnicalBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.primaryFixedDim.withValues(alpha: 0.025)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final wideLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.018)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 1.25,
        height: size.height * 0.42,
      ),
      wideLinePaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.94,
        height: size.height * 0.28,
      ),
      linePaint,
    );

    final path = Path()
      ..moveTo(0, size.height * 0.37)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..lineTo(size.width * 0.5, size.height * 0.36)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.37);

    canvas.drawPath(path, wideLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
