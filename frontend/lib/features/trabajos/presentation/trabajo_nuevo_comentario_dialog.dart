import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrabajoNuevoComentarioDialog extends StatefulWidget {
  final int trabajoId;
  const TrabajoNuevoComentarioDialog({super.key, required this.trabajoId});

  @override
  State<TrabajoNuevoComentarioDialog> createState() => _TrabajoNuevoComentarioDialogState();
}

class _TrabajoNuevoComentarioDialogState extends State<TrabajoNuevoComentarioDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Escribe tu comentario aquí...'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancelar'))),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _controller.text.trim().isEmpty ? null : () => context.pop(),
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
