import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const GanpatiTempleApp());
}

class GanpatiTempleApp extends StatelessWidget {
  const GanpatiTempleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganpati Temple',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'serif',
      ),
      home: const TempleView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TempleView extends StatefulWidget {
  const TempleView({super.key});

  @override
  State<TempleView> createState() => _TempleViewState();
}

class _TempleViewState extends State<TempleView>
    with TickerProviderStateMixin {
  late AnimationController _thalController;
  late AnimationController _diyaController;
  late AnimationController _bellController;
  late AnimationController _glowController;
  late AnimationController _flameController;
  late AnimationController _petalController;
  late AnimationController _sparkleController;

  bool _isAartiPlaying = false;
  bool _isBellRinging = false;

  @override
  void initState() {
    super.initState();
    
    // Set full screen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    // Initialize animation controllers
    _thalController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _diyaController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _bellController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _flameController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    
    _petalController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _thalController.dispose();
    _diyaController.dispose();
    _bellController.dispose();
    _glowController.dispose();
    _flameController.dispose();
    _petalController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  void _toggleAarti() async {
    if (_isAartiPlaying) {
      _thalController.stop();
      _diyaController.stop();
      _bellController.stop();
      setState(() {
        _isAartiPlaying = false;
      });
    } else {
      _thalController.repeat();
      _diyaController.repeat(reverse: true);
      _bellController.repeat(reverse: true);
      setState(() {
        _isAartiPlaying = true;
      });
    }
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _ringBell() async {
    if (!_isBellRinging) {
      setState(() {
        _isBellRinging = true;
      });
      
      // Haptic feedback for bell
      HapticFeedback.mediumImpact();
      
      // Animate bell swing once
      _bellController.reset();
      await _bellController.forward();
      await _bellController.reverse();
      
      setState(() {
        _isBellRinging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, -0.8),
            radius: 1.5,
            colors: [
              Color(0xFFFFF8DC), // Cornsilk
              Color(0xFFFFE4B5), // Moccasin
              Color(0xFFFFA500), // Orange
              Color(0xFFFF8C00), // Dark Orange
              Color(0xFFCD853F), // Peru
              Color(0xFF8B4513), // Saddle Brown
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating flower petals
            _buildFloatingPetals(),
            
            // Sparkle effects
            _buildSparkleEffect(),
            
            // Main Content
            SafeArea(
              child: Column(
                children: [
                  // Temple Header with Om
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _buildTempleHeader(),
                  ),
                  
                  // Temple Bell
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: _buildTempleBell(),
                  ),
                  
                  // Ganpati with Divine Glow
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: _buildGanpatiWithDivineAura(),
                    ),
                  ),
                  
                  // Rotating Thal with Offerings
                  if (_isAartiPlaying)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: _buildRotatingThal(),
                    ),
                  
                  // Control Buttons
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildControlButtons(),
                  ),
                  
                  // Diyas with Realistic Flames
                  _buildDiyaRow(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700), // Gold
            Color(0xFFFFA500), // Orange
            Color(0xFFFFD700), // Gold
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Text(
        '🕉️ श्री गणेशाय नमः 🕉️',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B4513),
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              color: Colors.white,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPetals() {
    return AnimatedBuilder(
      animation: _petalController,
      builder: (context, child) {
        return CustomPaint(
          painter: PetalPainter(_petalController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildSparkleEffect() {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return CustomPaint(
          painter: SparklePainter(_sparkleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildTempleBell() {
    return AnimatedBuilder(
      animation: _bellController,
      builder: (context, child) {
        double swingAngle = _isAartiPlaying 
            ? math.sin(_bellController.value * 2 * math.pi) * 0.2 
            : math.sin(_bellController.value * 2 * math.pi) * 0.4;
            
        return Transform.rotate(
          angle: swingAngle,
          child: CustomPaint(
            painter: BellPainter(),
            size: const Size(70, 90),
          ),
        );
      },
    );
  }

  Widget _buildGanpatiWithDivineAura() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Divine Aura Layers
            for (int i = 3; i >= 0; i--)
              Container(
                width: 280 + (i * 40) + (_glowController.value * 30),
                height: 280 + (i * 40) + (_glowController.value * 30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.transparent,
                      [
                        Colors.yellow.withOpacity(0.3),
                        Colors.orange.withOpacity(0.25),
                        Colors.pink.withOpacity(0.2),
                        Colors.purple.withOpacity(0.15),
                      ][i],
                    ],
                  ),
                ),
              ),
            
            // Main Ganpati Figure
            CustomPaint(
              painter: GanpatiPainter(_glowController.value),
              size: const Size(220, 220),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRotatingThal() {
    return AnimatedBuilder(
      animation: _thalController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _thalController.value * 2 * math.pi,
          child: CustomPaint(
            painter: ThalPainter(),
            size: const Size(140, 140),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Aarti Button
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isAartiPlaying 
                  ? [Colors.red.shade400, Colors.red.shade700]
                  : [Colors.green.shade400, Colors.green.shade700],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: (_isAartiPlaying ? Colors.red : Colors.green).withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _toggleAarti,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_isAartiPlaying ? Icons.pause : Icons.play_arrow, size: 28),
                // const SizedBox(width: 8),
                // Text(
                //   _isAartiPlaying ? 'विराम आरती' : 'आरती शुरू',
                //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
        
        // Bell Button
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade400, Colors.amber.shade700],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isBellRinging ? null : _ringBell,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_active, size: 28),
                // SizedBox(width: 8),
                // Text(
                //   'घंटी बजाएं',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiyaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) => _buildDiya(index)),
    );
  }

  Widget _buildDiya(int index) {
    return AnimatedBuilder(
      animation: _flameController,
      builder: (context, child) {
        return CustomPaint(
          painter: DiyaPainter(_flameController.value, index),
          size: const Size(40, 50),
        );
      },
    );
  }
}

// Custom Painter for Flower Petals
class PetalPainter extends CustomPainter {
  final double animationValue;
  
  PetalPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < 15; i++) {
      final x = (size.width * 0.1) + (i * size.width * 0.06) + 
               (math.sin(animationValue * 2 * math.pi + i) * 20);
      final y = (animationValue * size.height * 1.2 + i * 50) % (size.height + 100);
      
      paint.color = [
        Colors.pink.withOpacity(0.7),
        Colors.orange.withOpacity(0.6),
        Colors.yellow.withOpacity(0.8),
        Colors.red.withOpacity(0.5),
      ][i % 4];
      
      // Draw petal shape
      final path = Path();
      path.moveTo(x, y);
      path.quadraticBezierTo(x + 8, y - 5, x + 4, y - 12);
      path.quadraticBezierTo(x, y - 8, x - 4, y - 12);
      path.quadraticBezierTo(x - 8, y - 5, x, y);
      
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Sparkle Effect
class SparklePainter extends CustomPainter {
  final double animationValue;
  
  SparklePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (int i = 0; i < 20; i++) {
      final x = (i * 50.0 + animationValue * 100) % size.width;
      final y = (i * 80.0 + animationValue * 150) % size.height;
      final opacity = (math.sin(animationValue * 4 * math.pi + i) + 1) / 2;
      
      paint.color = Colors.white.withOpacity(opacity * 0.8);
      
      // Draw sparkle
      canvas.drawCircle(Offset(x, y), 2, paint);
      
      // Draw sparkle rays
      for (int j = 0; j < 4; j++) {
        final angle = (math.pi * 2 * j / 4) + (animationValue * math.pi * 2);
        final startX = x + math.cos(angle) * 3;
        final startY = y + math.sin(angle) * 3;
        final endX = x + math.cos(angle) * 8;
        final endY = y + math.sin(angle) * 8;
        
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          Paint()
            ..color = Colors.white.withOpacity(opacity * 0.6)
            ..strokeWidth = 1,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Temple Bell
class BellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Bell gradient
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.amber.shade200,
        Colors.amber.shade600,
        Colors.brown.shade700,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Bell shape
    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.7, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width * 0.2, size.height * 0.7);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Bell highlight
    paint.shader = LinearGradient(
      colors: [Colors.white.withOpacity(0.6), Colors.transparent],
    ).createShader(Rect.fromLTWH(0, 0, size.width * 0.4, size.height * 0.6));
    
    final highlightPath = Path();
    highlightPath.moveTo(size.width * 0.35, size.height * 0.25);
    highlightPath.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.45, size.height * 0.3);
    highlightPath.lineTo(size.width * 0.4, size.height * 0.6);
    highlightPath.quadraticBezierTo(size.width * 0.37, size.height * 0.4, size.width * 0.35, size.height * 0.25);
    
    canvas.drawPath(highlightPath, paint);
    
    // Bell rope
    paint
      ..shader = null
      ..color = Colors.brown.shade600;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.1),
        width: 3,
        height: size.height * 0.2,
      ),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Ganpati
class GanpatiPainter extends CustomPainter {
  final double glowValue;
  
  GanpatiPainter(this.glowValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Body gradient
    paint.shader = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: [
        Colors.orange.shade200,
        Colors.orange.shade400,
        Colors.orange.shade700,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 30),
        width: 80,
        height: 70,
      ),
      paint,
    );
    
    // Body
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY + 20),
        width: 90,
        height: 60,
      ),
      paint,
    );
    
    // Ears
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 45, centerY - 35),
        width: 30,
        height: 45,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 45, centerY - 35),
        width: 30,
        height: 45,
      ),
      paint,
    );
    
    // Trunk
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.orange.shade300,
        Colors.orange.shade600,
      ],
    ).createShader(Rect.fromLTWH(centerX - 15, centerY - 10, 30, 40));
    
    final trunkPath = Path();
    trunkPath.moveTo(centerX, centerY - 10);
    trunkPath.quadraticBezierTo(centerX - 10, centerY, centerX + 5, centerY + 15);
    trunkPath.quadraticBezierTo(centerX + 15, centerY + 25, centerX, centerY + 30);
    trunkPath.quadraticBezierTo(centerX - 8, centerY + 20, centerX - 5, centerY);
    trunkPath.close();
    
    canvas.drawPath(trunkPath, paint);
    
    // Eyes
    paint
      ..shader = null
      ..color = Colors.black;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 15, centerY - 40),
        width: 8,
        height: 10,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + 15, centerY - 40),
        width: 8,
        height: 10,
      ),
      paint,
    );
    
    // Crown
    paint.shader = LinearGradient(
      colors: [Colors.yellow.shade300, Colors.yellow.shade700],
    ).createShader(Rect.fromLTWH(centerX - 50, centerY - 80, 100, 30));
    
    final crownPath = Path();
    crownPath.moveTo(centerX - 45, centerY - 55);
    crownPath.lineTo(centerX - 30, centerY - 75);
    crownPath.lineTo(centerX - 15, centerY - 60);
    crownPath.lineTo(centerX, centerY - 80);
    crownPath.lineTo(centerX + 15, centerY - 60);
    crownPath.lineTo(centerX + 30, centerY - 75);
    crownPath.lineTo(centerX + 45, centerY - 55);
    crownPath.close();
    
    canvas.drawPath(crownPath, paint);
    
    // Tilak
    paint
      ..shader = null
      ..color = Colors.red.shade600;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 50),
        width: 6,
        height: 15,
      ),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Thal (Plate)
class ThalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // Thal plate
    paint.shader = RadialGradient(
      colors: [
        Colors.amber.shade100,
        Colors.amber.shade400,
        Colors.amber.shade700,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawCircle(center, size.width / 2 - 5, paint);
    
    // Plate rim
    paint
      ..shader = null
      ..color = Colors.amber.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, size.width / 2 - 5, paint);
    
    paint.style = PaintingStyle.fill;
    
    // Laddus
    final ladduPositions = [
      Offset(center.dx - 25, center.dy - 15),
      Offset(center.dx + 25, center.dy - 15),
      Offset(center.dx - 15, center.dy + 20),
      Offset(center.dx + 15, center.dy + 20),
      Offset(center.dx, center.dy - 5),
    ];
    
    for (final pos in ladduPositions) {
      paint.shader = RadialGradient(
        colors: [
          Colors.orange.shade300,
          Colors.orange.shade600,
          Colors.brown.shade600,
        ],
      ).createShader(Rect.fromCenter(center: pos, width: 20, height: 20));
      
      canvas.drawCircle(pos, 10, paint);
    }
    
    // Flowers
    paint
      ..shader = null
      ..color = Colors.pink.shade300;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8);
      final flowerPos = Offset(
        center.dx + math.cos(angle) * 35,
        center.dy + math.sin(angle) * 35,
      );
      
      for (int j = 0; j < 5; j++) {
        final petalAngle = angle + (j * math.pi * 2 / 5);
        final petalPos = Offset(
          flowerPos.dx + math.cos(petalAngle) * 4,
          flowerPos.dy + math.sin(petalAngle) * 4,
        );
        canvas.drawCircle(petalPos, 3, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Diya
class DiyaPainter extends CustomPainter {
  final double flameValue;
  final int index;
  
  DiyaPainter(this.flameValue, this.index);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final centerX = size.width / 2;
    final diyaY = size.height * 0.8;
    
    // Diya base
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.brown.shade400,
        Colors.brown.shade700,
        Colors.brown.shade900,
      ],
    ).createShader(Rect.fromLTWH(0, diyaY - 10, size.width, 20));
    
    final diyaPath = Path();
    diyaPath.moveTo(centerX - 15, diyaY);
    diyaPath.quadraticBezierTo(centerX - 18, diyaY - 5, centerX - 15, diyaY - 10);
    diyaPath.lineTo(centerX + 15, diyaY - 10);
    diyaPath.quadraticBezierTo(centerX + 18, diyaY - 5, centerX + 15, diyaY);
    diyaPath.quadraticBezierTo(centerX, diyaY + 5, centerX - 15, diyaY);
    
    canvas.drawPath(diyaPath, paint);
    
    // Flame
    final flameHeight = 20 + (flameValue * 8);
    final flameWidth = 8 + (flameValue * 3);
    
    paint.shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.red.shade600,
        Colors.orange.shade500,
        Colors.yellow.shade400,
        Colors.white.withOpacity(0.9),
      ],
    ).createShader(Rect.fromCenter(
      center: Offset(centerX, diyaY - 10 - flameHeight/2),
      width: flameWidth,
      height: flameHeight,
    ));
    
    // Flame shape with flicker
    final flamePath = Path();
    final flameBaseY = diyaY - 10;
    final flameTipY = flameBaseY - flameHeight;
    final flicker = math.sin(flameValue * 2 * math.pi + index) * 2;
    
    flamePath.moveTo(centerX - flameWidth/2, flameBaseY);
    flamePath.quadraticBezierTo(
      centerX - flameWidth/3 + flicker, 
      flameBaseY - flameHeight * 0.3, 
      centerX + flicker, 
      flameTipY
    );
    flamePath.quadraticBezierTo(
      centerX + flameWidth/3 + flicker, 
      flameBaseY - flameHeight * 0.3, 
      centerX + flameWidth/2, 
      flameBaseY
    );
    flamePath.close();
    
    canvas.drawPath(flamePath, paint);
    
    // Inner flame glow
    paint.shader = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.8),
        Colors.yellow.withOpacity(0.6),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCenter(
      center: Offset(centerX + flicker, flameTipY + flameHeight * 0.3),
      width: flameWidth * 0.6,
      height: flameHeight * 0.6,
    ));
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + flicker, flameTipY + flameHeight * 0.3),
        width: flameWidth * 0.6,
        height: flameHeight * 0.6,
      ),
      paint,
    );
    
    // Wick
    paint
      ..shader = null
      ..color = Colors.black87;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, flameBaseY - 2),
        width: 2,
        height: 4,
      ),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
