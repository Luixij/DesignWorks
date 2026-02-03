// =======================
// ENUMS
// =======================

enum EstadoTrabajo {
  CREADO,
  EN_PROGRESO,
  EN_REVISION,
  ENTREGADO,
  CANCELADO,
}

enum Prioridad {
  BAJA,
  MEDIA,
  ALTA,
  URGENTE,
}

enum Rol {
  ADMIN,
  DISENADOR,
}

// =======================
// STRING -> ENUM
// =======================

extension EnumJson on String {
  EstadoTrabajo toEstadoTrabajo() {
    switch (this) {
      case 'CREADO':
        return EstadoTrabajo.CREADO;
      case 'EN_PROGRESO':
        return EstadoTrabajo.EN_PROGRESO;
      case 'EN_REVISION':
        return EstadoTrabajo.EN_REVISION;
      case 'ENTREGADO':
        return EstadoTrabajo.ENTREGADO;
      case 'CANCELADO':
        return EstadoTrabajo.CANCELADO;
      default:
        throw ArgumentError('EstadoTrabajo desconocido: $this');
    }
  }

  Prioridad toPrioridad() {
    switch (this) {
      case 'BAJA':
        return Prioridad.BAJA;
      case 'MEDIA':
        return Prioridad.MEDIA;
      case 'ALTA':
        return Prioridad.ALTA;
      case 'URGENTE':
        return Prioridad.URGENTE;
      default:
        throw ArgumentError('Prioridad desconocida: $this');
    }
  }

  /// ❗ Estricta (lanza excepción)
  Rol toRol() {
    final normalized = toUpperCase().trim();

    switch (normalized) {
      case 'ADMIN':
        return Rol.ADMIN;
      case 'DISENADOR':
      case 'DISEÑADOR':
        return Rol.DISENADOR;
      default:
        throw ArgumentError('Rol desconocido: $this');
    }
  }

  /// SEGURA (no lanza excepción)
  Rol? toRolOrNull() {
    final normalized = toUpperCase().trim();

    switch (normalized) {
      case 'ADMIN':
        return Rol.ADMIN;
      case 'DISENADOR':
      case 'DISEÑADOR':
        return Rol.DISENADOR;
      default:
        return null;
    }
  }
}

// =======================
// ENUM -> JSON
// =======================

extension EstadoTrabajoToJson on EstadoTrabajo {
  String toJson() => name;
}

extension PrioridadToJson on Prioridad {
  String toJson() => name;
}

extension RolToJson on Rol {
  String toJson() => name;
}
