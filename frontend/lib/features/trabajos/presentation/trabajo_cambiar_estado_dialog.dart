import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';

// Paleta coherente con el resto del sistema
const _estadoColors = {
  EstadoTrabajo.EN_PROGRESO: (
  bg: Color(0xFFB5D5A8),
  fg: Color(0xFF2D5A1B),
  label: 'En progreso',
  ),
  EstadoTrabajo.EN_REVISION: (
  bg: Color(0xFF8ECFBB),
  fg: Color(0xFF1A5A46),
  label: 'En revisión',
  ),
  EstadoTrabajo.ENTREGADO: (
  bg: Color(0xFF9DB8D9),
  fg: Color(0xFF1A3A5A),
  label: 'Entregado',
  ),
  EstadoTrabajo.CREADO: (
  bg: Color(0xFFD4D97A),
  fg: Color(0xFF4A4E0A),
  label: 'Creado',
  ),
  EstadoTrabajo.CANCELADO: (
  bg: Color(0xFFE8A598),
  fg: Color(0xFF5A1A10),
  label: 'Cancelado',
  ),
};

class TrabajoCambiarEstadoDialog extends ConsumerStatefulWidget {
  final int trabajoId;
  const TrabajoCambiarEstadoDialog({super.key, required this.trabajoId});

  @override
  ConsumerState<TrabajoCambiarEstadoDialog> createState() =>
      _TrabajoCambiarEstadoDialogState();
}

class _TrabajoCambiarEstadoDialogState
    extends ConsumerState<TrabajoCambiarEstadoDialog> {
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
      if (mounted) context.pop();
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
    // Leemos el estado actual del detalle para mostrarlo
    final asyncDetail = ref.watch(trabajoDetailProvider(widget.trabajoId));
    final estadoActual = asyncDetail.valueOrNull?.estadoActual;

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
              'Cambiar estado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),

            // ── Estado actual ────────────────────────────────────────────
            const Text(
              'Estado actual',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF8A8FA3),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            if (estadoActual != null) ...[
              _EstadoBadge(estado: estadoActual),
            ],
            const SizedBox(height: 4),
            const Divider(color: Color(0xFFDDDDDD)),
            const SizedBox(height: 12),

            // ── Nuevo estado ─────────────────────────────────────────────
            const Text(
              'Nuevo estado',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF8A8FA3),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _EstadoSelector(
              selected: _nuevoEstado,
              enabled: !_loading,
              onChanged: (v) => setState(() => _nuevoEstado = v),
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
                  label: 'Aceptar',
                  onTap: (_nuevoEstado == null || _loading) ? null : _onAceptar,
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


// ── Selector de estado inline (no desplaza botones) ──────────────────────────

class _EstadoSelector extends StatefulWidget {
  final EstadoTrabajo? selected;
  final bool enabled;
  final ValueChanged<EstadoTrabajo> onChanged;

  const _EstadoSelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<_EstadoSelector> createState() => _EstadoSelectorState();
}

class _EstadoSelectorState extends State<_EstadoSelector> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.selected != null ? _estadoColors[widget.selected!]! : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Cabecera del selector ──────────────────────────────────────
        GestureDetector(
          onTap: widget.enabled ? () => setState(() => _open = !_open) : null,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (colors != null) ...[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.bg,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    colors.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ] else
                  const Text(
                    'Nuevo estado',
                    style: TextStyle(color: Color(0xFF8A8FA3), fontSize: 14),
                  ),
                const Spacer(),
                Icon(
                  _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFF8A8FA3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // ── Opciones desplegadas hacia abajo, inline ───────────────────
        if (_open) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: EstadoTrabajo.values.map((e) {
                final c = _estadoColors[e]!;
                final isSelected = widget.selected == e;
                return GestureDetector(
                  onTap: () {
                    widget.onChanged(e);
                    setState(() => _open = false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? c.bg.withOpacity(0.3) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: c.bg,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          c.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? c.fg : const Color(0xFF2D3142),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Badge de estado (igual al resto del sistema) ──────────────────────────────

class _EstadoBadge extends StatelessWidget {
  final EstadoTrabajo estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final colors = _estadoColors[estado]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        colors.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colors.fg,
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