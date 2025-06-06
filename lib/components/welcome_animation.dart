import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Widget de animación mejorado para la pantalla de bienvenida
class WelcomeAnimation extends StatefulWidget {
  final String username;

  const WelcomeAnimation({super.key, required this.username});

  @override
  State<WelcomeAnimation> createState() => _WelcomeAnimationState();
}

class _WelcomeAnimationState extends State<WelcomeAnimation>
    with TickerProviderStateMixin {
  // Múltiples controladores para efectos más complejos
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particlesController;

  // Animaciones principales
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  // Animaciones secundarias
  late Animation<double> _pulseAnimation;
  late Animation<double> _particlesOpacity;

  // Lista de partículas para el efecto confeti
  final List<Particle> _particles = List.generate(30, (_) => Particle.random());

  @override
  void initState() {
    super.initState();

    // Controlador principal
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Controlador para el efecto de pulso continuo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Controlador para partículas/confeti
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Animación para aparecer gradualmente
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Animación para escala con efecto de rebote
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Animación de deslizamiento para el texto
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Efecto de pulso continuo para el brillo
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(_pulseController);

    // Opacidad para partículas
    _particlesOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _particlesController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // Iniciar la secuencia de animaciones
    _mainController.forward().then((_) {
      _particlesController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _pulseController,
        _particlesController,
      ]),
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Fondo con brillo pulsante
            if (_fadeInAnimation.value > 0.5)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0 * _pulseAnimation.value,
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.0),
                            theme.colorScheme.primary.withOpacity(0.05),
                            theme.colorScheme.primary.withOpacity(0.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Partículas animadas
            if (_mainController.value > 0.9)
              Opacity(
                opacity: _particlesOpacity.value,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 400),
                  painter: ParticlePainter(
                    particles: _particles,
                    progress: _particlesController.value,
                  ),
                ),
              ),

            // Contenido principal
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícono animado
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeInAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(60),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(child: WelcomeIcon()),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Texto de bienvenida animado
                Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeInAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          '¡Bienvenido!',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.username,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // Mensaje adicional que aparece más tarde
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 800),
                          opacity: _mainController.value > 0.8 ? 1.0 : 0.0,
                          child: Text(
                            'Estamos preparando todo para ti...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Ícono personalizado para la pantalla de bienvenida (mejorado)
class WelcomeIcon extends StatelessWidget {
  const WelcomeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WelcomeIconPainter(Theme.of(context).colorScheme.primary),
      size: const Size(90, 90),
    );
  }
}

/// CustomPainter para dibujar un icono de bienvenida más elegante
class WelcomeIconPainter extends CustomPainter {
  final Color primaryColor;

  WelcomeIconPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);

    // Gradiente principal (más suave y elegante)
    final Paint primaryPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              primaryColor.withOpacity(0.9),
              primaryColor,
              primaryColor.withBlue(math.min(255, primaryColor.blue + 40)),
            ],
            stops: const [0.0, 0.6, 1.0],
            center: const Alignment(0.2, -0.2),
          ).createShader(Rect.fromLTWH(0, 0, width, height))
          ..style = PaintingStyle.fill;

    // Pinta el círculo principal con gradiente
    final mainRadius = width * 0.38;
    canvas.drawCircle(center, mainRadius, primaryPaint);

    // Añade un borde brillante exterior
    final outerGlowPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 0.03;

    canvas.drawCircle(center, mainRadius * 1.25, outerGlowPaint);

    // Círculo brillante interior
    final innerCirclePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center.translate(-width * 0.08, -height * 0.08),
      mainRadius * 0.15,
      innerCirclePaint,
    );

    // Dibuja el gesto de bienvenida (un brazo estilizado)
    final armPath = Path();

    // Punto inicial (mano)
    armPath.moveTo(width * 0.35, height * 0.65);

    // Curva del brazo (control1, control2, punto final)
    armPath.cubicTo(
      width * 0.5,
      height * 0.75, // control 1
      width * 0.7,
      height * 0.6, // control 2
      width * 0.75,
      height * 0.4, // punto final
    );

    // Pinta el brazo
    final armPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 0.09
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(armPath, armPaint);

    // Añade la "mano" al final del brazo
    canvas.drawCircle(
      Offset(width * 0.75, height * 0.4),
      width * 0.08,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Clase para representar una partícula en el efecto confeti
class Particle {
  final Color color;
  final double size;
  final Offset initialPosition;
  final Offset velocity;
  final double rotationSpeed;

  Particle({
    required this.color,
    required this.size,
    required this.initialPosition,
    required this.velocity,
    required this.rotationSpeed,
  });

  factory Particle.random() {
    final random = math.Random();

    // Colores festivos
    final colors = [
      Colors.blue.shade300,
      Colors.blue.shade500,
      Colors.lightBlue.shade300,
      Colors.lightBlue.shade500,
      Colors.white,
    ];

    return Particle(
      color: colors[random.nextInt(colors.length)],
      size: 5.0 + random.nextDouble() * 8.0,
      initialPosition: Offset(
        -30 + random.nextDouble() * 60,
        -150 + random.nextDouble() * 50,
      ),
      velocity: Offset(
        -1.5 + random.nextDouble() * 3.0,
        2.0 + random.nextDouble() * 3.0,
      ),
      rotationSpeed: (random.nextDouble() - 0.5) * 0.3,
    );
  }

  Offset calculatePosition(double progress) {
    return initialPosition + velocity * progress * 200;
  }
}

/// CustomPainter para dibujar las partículas confeti
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 160);

    for (final particle in particles) {
      final position = center + particle.calculatePosition(progress);
      final rotation = particle.rotationSpeed * progress * 10;

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);

      // Dibuja diferentes formas para las partículas
      final random = math.Random(particles.indexOf(particle));
      final shapeType = random.nextInt(3);

      final paint = Paint()..color = particle.color;

      if (shapeType == 0) {
        // Dibuja un círculo
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      } else if (shapeType == 1) {
        // Dibuja un cuadrado
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size,
          ),
          paint,
        );
      } else {
        // Dibuja un diamante
        final diamondPath =
            Path()
              ..moveTo(0, -particle.size / 2)
              ..lineTo(particle.size / 2, 0)
              ..lineTo(0, particle.size / 2)
              ..lineTo(-particle.size / 2, 0)
              ..close();

        canvas.drawPath(diamondPath, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
