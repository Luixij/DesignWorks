import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrabajoCambiarEstadoDialog extends StatefulWidget {
  final int trabajoId;
  const TrabajoCambiarEstadoDialog({super.key, required this.trabajoId});

  @override
  State<TrabajoCambiarEstadoDialog> createState() => _TrabajoCambiarEstadoDialogState();
}

class _TrabajoCambiarEstadoDialogState extends State<TrabajoCambiarEstadoDialog> {
  String? _nuevoEstado;

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
          const Align(alignment: Alignment.centerLeft, child: Text('Estado actual')),
          const SizedBox(height: 8),
          const Chip(label: Text('En progreso')), // placeholder
          const Divider(height: 24),
          DropdownButtonFormField<String>(
            value: _nuevoEstado,
            items: const [
              DropdownMenuItem(value: 'CREADO', child: Text('Creado')),
              DropdownMenuItem(value: 'EN_PROGRESO', child: Text('En progreso')),
              DropdownMenuItem(value: 'EN_REVISION', child: Text('En revisión')),
              DropdownMenuItem(value: 'ENTREGADO', child: Text('Entregado')),
              DropdownMenuItem(value: 'CANCELADO', child: Text('Cancelado')),
            ],
            onChanged: (v) => setState(() => _nuevoEstado = v),
            decoration: const InputDecoration(labelText: 'Nuevo estado'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nuevoEstado == null ? null : () => context.pop(),
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
