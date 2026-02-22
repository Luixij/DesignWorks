import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';
import 'trabajo_cambiar_estado_dialog.dart';
import 'trabajo_historial_screen.dart';
import 'trabajo_nuevo_comentario_dialog.dart';

const _kBgColor = Color(0xFFF4F4F2);
const _kPadH = 20.0;

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

class TrabajoDetailScreen extends ConsumerWidget {
  final int trabajoId;
  const TrabajoDetailScreen({super.key, required this.trabajoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(trabajoDetailProvider(trabajoId));

    return Scaffold(
      backgroundColor: _kBgColor,
      appBar: AppBar(
        backgroundColor: _kBgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.only(left: _kPadH, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF2D3142),
            ),
          ),
        ),
        leadingWidth: 60,
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $e'),
            ],
          ),
        ),
        data: (detail) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Título + badge estado ──────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      detail.titulo,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _EstadoBadge(estado: detail.estadoActual),
                ],
              ),
              const SizedBox(height: 8),

              // ── Subtítulo ──────────────────────────────────────────────
              Text(
                detail.descripcion.split('.').first,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A8FA3),
                ),
              ),
              const SizedBox(height: 24),

              // ── Equipo ─────────────────────────────────────────────────
              const Text(
                'Equipo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3142),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              _buildEquipoSection(detail.participantes),
              const SizedBox(height: 24),

              // ── Botones de acción ──────────────────────────────────────
              Row(
                children: [
                  _ActionButton(
                    label: 'Cambiar estado',
                    backgroundColor: const Color(0xFF8ECFBB),
                    textColor: const Color(0xFF1A5A46),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) =>
                          TrabajoCambiarEstadoDialog(trabajoId: trabajoId),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    label: 'Ver historial',
                    backgroundColor: const Color(0xFFD4D97A),
                    textColor: const Color(0xFF4A4E0A),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) =>
                          TrabajoHistorialScreen(trabajoId: trabajoId),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Imagen fusionada con la card de descripción ────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen — primer adjunto_url de los requisitos que no sea null
                    Builder(builder: (context) {
                      final imagenUrl = detail.requisitos
                          .where((r) => r.adjuntoUrl != null && r.adjuntoUrl!.isNotEmpty)
                          .map((r) => r.adjuntoUrl!)
                          .firstOrNull;
                      if (imagenUrl != null) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24)),
                          child: Image.network(
                            imagenUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) =>
                            progress == null
                                ? child
                                : Container(
                              height: 200,
                              color: const Color(0xFFD0D5E8),
                              child: const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            ),
                            errorBuilder: (_, __, ___) => Container(
                              width: double.infinity,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD0D5E8),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24)),
                              ),
                              child: const Icon(Icons.broken_image_outlined,
                                  size: 48, color: Color(0xFF8A8FA3)),
                            ),
                          ),
                        );
                      }
                      // Placeholder si ningún requisito tiene adjunto_url
                      return ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          color: const Color(0xFFD0D5E8),
                          child: const Icon(Icons.image_outlined,
                              size: 48, color: Color(0xFF8A8FA3)),
                        ),
                      );
                    }),

                    // Contenido de la card
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título Descripción con color del estado
                          Text(
                            'Descripción',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                              _estadoColors[detail.estadoActual]?.fg ??
                                  const Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            detail.descripcion,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4E5A),
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Color(0xFFEEEEEE), height: 1),
                          const SizedBox(height: 16),
                          // Cliente + Fecha inicio
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cliente',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF8A8FA3),
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      detail.cliente,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fecha inicio',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF8A8FA3),
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatFecha(detail.fechaInicio),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3142),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Requisitos ─────────────────────────────────────────────
              const Text(
                'Requisitos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              if (detail.requisitos.isEmpty)
                Text(
                  'No hay requisitos definidos',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.shade600),
                )
              else
                ...detail.requisitos.map(
                      (req) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                req.descripcion,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4A4E5A),
                                  height: 1.4,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 28),

              // ── Comentarios ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comentarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => TrabajoNuevoComentarioDialog(
                          trabajoId: trabajoId),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (detail.comentarios.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No hay comentarios todavía',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ),
                )
              else
                ...detail.comentarios.map(
                      (comentario) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comentario.texto,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3142),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(
                            color: Color(0xFFEEEEEE), height: 1),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Color(0xFF8A8FA3),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatFechaComentario(comentario.fecha),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF8A8FA3),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              comentario.usuario.nombre,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipoSection(List<dynamic> participantes) {
    if (participantes.isEmpty) {
      return const Text(
        'Sin asignar',
        style: TextStyle(fontSize: 14, color: Color(0xFF8A8FA3)),
      );
    }

    return Row(
      children: [
        Text(
          participantes.first.nombre,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D3142),
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 36,
          width: 36.0 + (participantes.take(3).length - 1) * 26.0,
          child: Stack(
            children: [
              ...participantes.take(3).toList().asMap().entries.map((e) {
                final i = e.key;
                final p = e.value;
                return Positioned(
                  left: i * 26.0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD0D5E8),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        p.nombre.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _formatFecha(DateTime fecha) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }

  String _formatFechaComentario(DateTime fecha) {
    return '${fecha.day} ${_getNombreMes(fecha.month)}, ${fecha.year}';
  }

  String _getNombreMes(int mes) {
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return meses[mes - 1];
  }
}

// ── Estado Badge ──────────────────────────────────────────────────────────────

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

// ── Action Button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}