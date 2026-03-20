import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/trabajos_providers.dart';
import '../data/models/enums.dart';
import '../data/models/trabajo_create_request.dart';

const _kBgColor = Color(0xFFF4F4F2);
const _kPrimary = Color(0xFF2D3142);
const _kAccent = Color(0xFFBE3A2A);

class TrabajoNuevoScreen extends ConsumerStatefulWidget {
  const TrabajoNuevoScreen({super.key});

  @override
  ConsumerState<TrabajoNuevoScreen> createState() => _TrabajoNuevoScreenState();
}

class _TrabajoNuevoScreenState extends ConsumerState<TrabajoNuevoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloCtrl = TextEditingController();
  final _clienteCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  Prioridad _prioridad = Prioridad.MEDIA;
  DateTime? _fechaFin;
  bool _loading = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _clienteCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  // ── Comprueba si el usuario ha introducido algo ────────────────────────────
  bool get _tieneDatos =>
      _tituloCtrl.text.trim().isNotEmpty ||
          _clienteCtrl.text.trim().isNotEmpty ||
          _descripcionCtrl.text.trim().isNotEmpty ||
          _fechaFin != null;

  // ── Diálogo de confirmación al salir ──────────────────────────────────────
  Future<void> _onVolverAtras() async {
    if (!_tieneDatos) {
      context.pop();
      return;
    }

    final salir = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '¿Salir sin crear?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _kPrimary,
          ),
        ),
        content: const Text(
          'Si sales ahora perderás los datos introducidos.',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF8A8FA3),
          ),
        ),
        actions: [
          // Cancelar — vuelve al formulario conservando datos
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Seguir editando',
              style: TextStyle(
                color: _kPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Confirmar salida
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Salir',
              style: TextStyle(
                color: _kAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (salir == true && mounted) context.pop();
  }

  String _formatFecha(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _kAccent),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _fechaFin = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final request = TrabajoCreateRequest(
        titulo: _tituloCtrl.text.trim(),
        cliente: _clienteCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        prioridad: _prioridad,
        fechaFin: _fechaFin != null
            ? '${_fechaFin!.year}-${_fechaFin!.month.toString().padLeft(2, '0')}-${_fechaFin!.day.toString().padLeft(2, '0')}'
            : null,
      );

      final nuevo =
      await ref.read(trabajosActionsProvider).crearTrabajo(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Trabajo creado correctamente'),
            backgroundColor: Color(0xFF2D5A1B),
          ),
        );
        context.go('/trabajos/${nuevo.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el trabajo: $e'),
            backgroundColor: _kAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // PopScope intercepta el botón físico de atrás del dispositivo
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onVolverAtras();
      },
      child: Scaffold(
        backgroundColor: _kBgColor,
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón volver con diálogo
                    GestureDetector(
                      onTap: _onVolverAtras,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: _kPrimary,
                        ),
                      ),
                    ),

                    const Text(
                      'Nuevo proyecto',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _kPrimary,
                      ),
                    ),

                    _loading
                        ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _kAccent,
                          ),
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: _submit,
                      child: const Text(
                        'Crear',
                        style: TextStyle(
                          color: _kAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Formulario ────────────────────────────────────────────────
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    children: [
                      _SectionLabel('Título del proyecto'),
                      _Field(
                        controller: _tituloCtrl,
                        hint: 'Ej: Rediseño web corporativa',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _SectionLabel('Cliente'),
                      _Field(
                        controller: _clienteCtrl,
                        hint: 'Nombre del cliente o empresa',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _SectionLabel('Descripción'),
                      _Field(
                        controller: _descripcionCtrl,
                        hint: 'Describe el alcance del proyecto...',
                        maxLines: 4,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 24),

                      _SectionLabel('Prioridad'),
                      const SizedBox(height: 10),
                      _PrioridadSelector(
                        selected: _prioridad,
                        onChanged: (p) => setState(() => _prioridad = p),
                      ),
                      const SizedBox(height: 24),

                      _SectionLabel('Fecha límite (opcional)'),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickFecha,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFDDDDDD)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 18, color: Color(0xFF8A8FA3)),
                              const SizedBox(width: 10),
                              Text(
                                _fechaFin != null
                                    ? _formatFecha(_fechaFin!)
                                    : 'Sin fecha límite',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _fechaFin != null
                                      ? _kPrimary
                                      : const Color(0xFF8A8FA3),
                                ),
                              ),
                              const Spacer(),
                              if (_fechaFin != null)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _fechaFin = null),
                                  child: const Icon(Icons.close,
                                      size: 18,
                                      color: Color(0xFF8A8FA3)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Crear proyecto',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
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
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8A8FA3),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: _kPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        const TextStyle(color: Color(0xFFB0B4C1), fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kAccent),
        ),
      ),
    );
  }
}

class _PrioridadSelector extends StatelessWidget {
  final Prioridad selected;
  final ValueChanged<Prioridad> onChanged;

  const _PrioridadSelector({
    required this.selected,
    required this.onChanged,
  });

  static const _opciones = [
    (valor: Prioridad.BAJA,    label: 'Baja',    color: Color(0xFF9DB8D9)),
    (valor: Prioridad.MEDIA,   label: 'Media',   color: Color(0xFFD4D97A)),
    (valor: Prioridad.ALTA,    label: 'Alta',    color: Color(0xFFB5D5A8)),
    (valor: Prioridad.URGENTE, label: 'Urgente', color: Color(0xFFE8A598)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _opciones.map((op) {
        final isSelected = selected == op.valor;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(op.valor),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? op.color : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? op.color
                        : const Color(0xFFDDDDDD),
                  ),
                ),
                child: Center(
                  child: Text(
                    op.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? _kPrimary
                          : const Color(0xFF8A8FA3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}