import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/trabajos_providers.dart';

class TrabajoNuevoComentarioDialog extends ConsumerStatefulWidget {
  final int trabajoId;
  const TrabajoNuevoComentarioDialog({super.key, required this.trabajoId});

  @override
  ConsumerState<TrabajoNuevoComentarioDialog> createState() =>
      _TrabajoNuevoComentarioDialogState();
}

class _TrabajoNuevoComentarioDialogState
    extends ConsumerState<TrabajoNuevoComentarioDialog> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onEnviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() => _loading = true);
    try {
      await ref.read(trabajosActionsProvider).crearComentario(
        trabajoId: widget.trabajoId,
        texto: texto,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error enviando comentario: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF4F4F2),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Título ──────────────────────────────────────────────────
            const Text(
              'Nuevo comentario',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(color: Color(0xFFDDDDDD)),
            const SizedBox(height: 12),

            // ── Campo de texto ───────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _controller,
                enabled: !_loading,
                maxLines: 5,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3142),
                ),
                decoration: InputDecoration(
                  hintText: 'Escribe tu comentario aquí...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF8A8FA3),
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 20),

            // ── Botones ──────────────────────────────────────────────────
            Row(
              children: [
                _DialogButton(
                  label: 'Cancelar',
                  onTap: _loading ? null : () => context.pop(),
                  outlined: true,
                ),
                const SizedBox(width: 12),
                _DialogButton(
                  label: 'Enviar',
                  onTap: (_controller.text.trim().isEmpty || _loading)
                      ? null
                      : _onEnviar,
                  backgroundColor: const Color(0xFF8ECFBB),
                  textColor: const Color(0xFF1A5A46),
                  loading: _loading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Botón reutilizable para dialogs ──────────────────────────────────────────

class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool outlined;
  final Color? backgroundColor;
  final Color? textColor;
  final bool loading;

  const _DialogButton({
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.backgroundColor,
    this.textColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: outlined ? Colors.white : (backgroundColor ?? const Color(0xFF8ECFBB)),
            borderRadius: BorderRadius.circular(20),
            border: outlined
                ? Border.all(color: const Color(0xFFDDDDDD))
                : null,
          ),
          child: Center(
            child: loading
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: outlined
                    ? const Color(0xFF2D3142)
                    : (textColor ?? const Color(0xFF1A5A46)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}