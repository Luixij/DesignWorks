import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/trabajos_providers.dart';

class TrabajoNuevoComentarioDialog extends ConsumerStatefulWidget {
  final int trabajoId;
  const TrabajoNuevoComentarioDialog({super.key, required this.trabajoId});

  @override
  ConsumerState<TrabajoNuevoComentarioDialog> createState() => _TrabajoNuevoComentarioDialogState();
}

class _TrabajoNuevoComentarioDialogState extends ConsumerState<TrabajoNuevoComentarioDialog> {
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

      if (mounted) context.pop(); // ← AQUÍ va el pop
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
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Nuevo comentario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            enabled: !_loading,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Escribe tu comentario aquí...'),
            onChanged: (_) => setState(() {}), // para habilitar/deshabilitar botón
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : () => context.pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_controller.text.trim().isEmpty || _loading) ? null : _onEnviar,
                  child: _loading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Enviar'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
