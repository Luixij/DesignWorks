import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../data/models/enums.dart';
import '../data/models/trabajo_list_item.dart';
import '../data/models/trabajo_detail.dart';
import '../data/models/historial_estado.dart';
import '../data/trabajos_repository.dart';
import '../../home/data/home_stats.dart';

final trabajosRepositoryProvider = Provider<TrabajosRepository>((ref) {
  final api = ref.read(apiClientProvider);
  final store = ref.read(secureStoreProvider);

  // ahora el repo necesita api + secureStore
  return TrabajosRepository(api, store);
});

/// Devuelve el rol leído desde SecureStore.
/// Si no hay rol guardado, devuelve null (mejor que inventar uno).
final userRolProvider = FutureProvider<Rol?>((ref) async {
  final store = ref.read(secureStoreProvider);
  final roleStr = await store.getRole();

  if (roleStr == null || roleStr.trim().isEmpty) {
    return null;
  }

  //  enums.dart ya tiene toRolOrNull()
  return roleStr.toRolOrNull();
});

final trabajosListProvider =
FutureProvider.autoDispose<List<TrabajoListItem>>((ref) async {
  // ya NO pasamos rol al repo
  final repo = ref.read(trabajosRepositoryProvider);
  return repo.getTrabajos();
});

final homeStatsProvider = FutureProvider.autoDispose<HomeStats>((ref) async {
  final trabajos = await ref.watch(trabajosListProvider.future);

  int enProgreso = 0;
  int enRevision = 0;
  int entregados = 0;
  int creados = 0;
  int cancelados = 0;

  for (final trabajo in trabajos) {
    switch (trabajo.estadoActual) {
      case EstadoTrabajo.CREADO:
        creados++;
        break;
      case EstadoTrabajo.EN_PROGRESO:
        enProgreso++;
        break;
      case EstadoTrabajo.EN_REVISION:
        enRevision++;
        break;
      case EstadoTrabajo.ENTREGADO:
        entregados++;
        break;
      case EstadoTrabajo.CANCELADO:
        cancelados++;
        break;
    }
  }

  return HomeStats(
    enProgreso: enProgreso,
    enRevision: enRevision,
    entregados: entregados,
    creados: creados,
    cancelados: cancelados,
    total: trabajos.length,
  );
});

final trabajoDetailProvider =
FutureProvider.autoDispose.family<TrabajoDetail, int>((ref, id) async {
  final repo = ref.read(trabajosRepositoryProvider);
  return repo.getTrabajoDetail(id);
});

final trabajoHistorialProvider = FutureProvider.autoDispose
    .family<List<HistorialEstado>, int>((ref, id) async {
  final repo = ref.read(trabajosRepositoryProvider);
  return repo.getHistorial(id);
});

final trabajosActionsProvider = Provider<TrabajosActions>((ref) {
  return TrabajosActions(ref);
});

class TrabajosActions {
  final Ref ref;
  TrabajosActions(this.ref);

  Future<void> refreshList() async {
    ref.invalidate(trabajosListProvider);
    await ref.read(trabajosListProvider.future);
  }

  Future<void> refreshDetail(int id) async {
    ref.invalidate(trabajoDetailProvider(id));
    await ref.read(trabajoDetailProvider(id).future);
  }

  Future<void> cambiarEstado({
    required int trabajoId,
    required EstadoTrabajo nuevoEstado,
    required String motivo,
  }) async {
    final repo = ref.read(trabajosRepositoryProvider);
    await repo.cambiarEstado(
      trabajoId: trabajoId,
      nuevoEstado: nuevoEstado,
      motivo: motivo,
    );

    ref.invalidate(trabajoDetailProvider(trabajoId));
    ref.invalidate(trabajosListProvider);
    ref.invalidate(homeStatsProvider);
    ref.invalidate(trabajoHistorialProvider(trabajoId));
  }

  Future<void> crearComentario({
    required int trabajoId,
    required String texto,
  }) async {
    final repo = ref.read(trabajosRepositoryProvider);
    await repo.crearComentario(trabajoId: trabajoId, texto: texto);

    ref.invalidate(trabajoDetailProvider(trabajoId));
  }
}
