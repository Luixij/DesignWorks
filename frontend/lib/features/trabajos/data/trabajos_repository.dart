import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_store.dart';
import '../data/models/enums.dart';
import '../data/models/trabajo_list_item.dart';
import '../data/models/trabajo_detail.dart';
import '../data/models/historial_estado.dart';

import '../data/models/trabajo_create_request.dart';

class TrabajosRepository {
  final ApiClient _api;
  final SecureStore _secureStore;

  TrabajosRepository(this._api, this._secureStore);

  Dio get _dio => _api.dio;

  /// ADMIN -> /trabajos (todos los trabajos)
  /// DISEÑADOR -> /trabajos/mis (solo mis trabajos)
  Future<List<TrabajoListItem>> getTrabajos() async {
    final roleStr = await _secureStore.getRole(); // "ADMIN" / "DISENADOR"
    final rol = roleStr?.toRolOrNull();

    if (rol == null) {
      throw Exception('❌ Rol no válido o no encontrado en SecureStore: $roleStr');
    }

    final path = rol == Rol.ADMIN ? '/trabajos' : '/trabajos/mis';

    print('🌐 Rol recibido: $rol');
    print('🌐 Endpoint a usar: $path');

    final res = await _dio.get(path);

    final list = (res.data as List<dynamic>)
        .map((e) => TrabajoListItem.fromJson(e as Map<String, dynamic>))
        .toList();

    print('✅ Trabajos obtenidos: ${list.length}');

    return list;
  }

  Future<TrabajoDetail> getTrabajoDetail(int id) async {
    final res = await _dio.get('/trabajos/$id');
    return TrabajoDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> cambiarEstado({
    required int trabajoId,
    required EstadoTrabajo nuevoEstado,
    required String motivo,
  }) async {
    await _dio.put(
      '/trabajos/$trabajoId/estado',
      data: {
        'nuevoEstado': nuevoEstado.toJson(),
        'motivo': motivo,
      },
    );
  }

  Future<void> crearComentario({
    required int trabajoId,
    required String texto,
  }) async {
    await _dio.post(
      '/trabajos/$trabajoId/comentarios',
      data: {'texto': texto},
    );
  }

  // POST
  Future<TrabajoDetail> crearTrabajo(TrabajoCreateRequest request) async {
    final res = await _dio.post(
      '/trabajos',
      data: request.toJson(),
    );
    return TrabajoDetail.fromJson(res.data as Map<String, dynamic>);
  }

  /// GET /trabajos/{trabajoId}/historial
  Future<List<HistorialEstado>> getHistorial(int trabajoId) async {
    final res = await _dio.get('/trabajos/$trabajoId/historial');
    final list = (res.data as List<dynamic>)
        .map((e) => HistorialEstado.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }
}
