import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/login_request.dart';
import '../../../core/providers.dart';

// ─────────────────────────────────────────────────────────────
// RUTA DEL LOGO — cambia este valor por la ruta de tu archivo
// ─────────────────────────────────────────────────────────────
const String _kLogoAsset = 'assets/images/logo_blanco.png';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);

      await authRepo.login(
        LoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permite que el body se redimensione cuando aparece el teclado
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7EC8D8),
              Color(0xFF8ECFBA),
            ],
          ),
        ),
        child: SafeArea(
          // SingleChildScrollView evita el overflow cuando aparece el teclado
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Ocupa al menos toda la altura disponible
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // ── Logo ──
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Image.asset(
                          _kLogoAsset,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const _LogoFallback(),
                        ),
                      ),
                    ),

                    // ── Formulario ──
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _GlassField(
                              controller: _emailController,
                              hint: 'Correo electrónico',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 14),
                            _GlassField(
                              controller: _passwordController,
                              hint: 'Contraseña',
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off,
                                  color: const Color(0xFF2D4A5A),
                                  size: 22,
                                ),
                                onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                              ),
                            ),

                            if (_error != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Color(0xFF8B0000),
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],

                            const SizedBox(height: 48),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD6EFE8),
                                  foregroundColor: const Color(0xFF2D4A5A),
                                  disabledBackgroundColor:
                                  const Color(0xFFD6EFE8).withOpacity(0.6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF2D4A5A),
                                  ),
                                )
                                    : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Footer ──
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24, top: 16),
                      child: Text(
                        '2026© LUIS IMAICELA',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D4A5A),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 48,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;

    final leftPath = Path()
      ..moveTo(0, size.height * 0.85)
      ..lineTo(size.width * 0.30, size.height * 0.10)
      ..lineTo(size.width * 0.54, size.height * 0.85)
      ..close();
    canvas.drawPath(leftPath, fillPaint);

    final rightPath = Path()
      ..moveTo(size.width * 0.44, size.height * 0.15)
      ..lineTo(size.width * 1.0, size.height * 0.15)
      ..lineTo(size.width * 0.72, size.height * 0.88)
      ..close();
    canvas.drawPath(rightPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const _GlassField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFD6EFE8).withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF1C3A47),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF4A7A8A),
            fontSize: 15,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}