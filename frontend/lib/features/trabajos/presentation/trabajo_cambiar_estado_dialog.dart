import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';

class TrabajoCambiarEstadoDialog extends ConsumerStatefulWidget {
  final int trabajoId;
  const TrabajoCambiarEstadoDialog({super.key, required this.trabajoId});

  @override
  ConsumerState<TrabajoCambiarEstadoDialog> createState() => _TrabajoCambiarEstadoDialogState();
}

class _TrabajoCambiarEstadoDialogState extends ConsumerState<TrabajoCambiarEstadoDialog> {
  EstadoTrabajo? _nuevoEstado;
  final _motivoCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _motivoCtrl.dispose();
    super.dispose();
  }

  Future<void> _onAceptar() async {
    if (_nuevoEstado == null) return;

    setState(() => _loading = true);
    try {
      await ref.read(trabajosActionsProvider).cambiarEstado(
        trabajoId: widget.trabajoId,
        nuevoEstado: _nuevoEstado!,
        motivo: _motivoCtrl.text.trim(),
      );

      if (mounted) context.pop(); // ← AQUÍ va el pop
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cambiando estado: $e')),
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
            child: Text('Cambiar estado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),

          // (Opcional) Estado actual: lo puedes leer del detalle si quieres
          // final detail = ref.watch(trabajoDetailProvider(widget.trabajoId));
          // ...

          DropdownButtonFormField<EstadoTrabajo>(
            value: _nuevoEstado,
            items: EstadoTrabajo.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
            onChanged: _loading ? null : (v) => setState(() => _nuevoEstado = v),
            decoration: const InputDecoration(labelText: 'Nuevo estado'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _motivoCtrl,
            enabled: !_loading,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Motivo (opcional)',
            ),
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
                  onPressed: (_nuevoEstado == null || _loading) ? null : _onAceptar,
                  child: _loading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Aceptar'),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
