package com.designworks.backend.services;

import java.time.LocalDateTime;
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.designworks.backend.dto.TrabajoMapper;
import com.designworks.backend.dto.request.CambiarEstadoRequest;
import com.designworks.backend.dto.request.ParticipanteRequest;
import com.designworks.backend.dto.request.TrabajoCreateRequest;
import com.designworks.backend.dto.response.TrabajoDetailResponse;
import com.designworks.backend.dto.response.TrabajoListItemResponse;
import com.designworks.backend.entities.HistorialEstado;
import com.designworks.backend.entities.Requisito;
import com.designworks.backend.entities.Trabajo;
import com.designworks.backend.entities.TrabajoParticipante;
import com.designworks.backend.entities.TrabajoParticipanteId;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.entities.enums.EstadoTrabajo;
import com.designworks.backend.repositories.ComentarioRepository;
import com.designworks.backend.repositories.HistorialEstadoRepository;
import com.designworks.backend.repositories.RequisitoRepository;
import com.designworks.backend.repositories.TrabajoParticipanteRepository;
import com.designworks.backend.repositories.TrabajoRepository;
import com.designworks.backend.repositories.UsuarioRepository;
import com.designworks.backend.security.AuthUserProvider;

@Service
public class TrabajoService {

    private final AuthUserProvider authUserProvider;
    private final PermissionService permissionService;

    private final TrabajoRepository trabajoRepository;
    private final UsuarioRepository usuarioRepository;
    private final TrabajoParticipanteRepository trabajoParticipanteRepository;
    private final RequisitoRepository requisitoRepository;
    private final ComentarioRepository comentarioRepository;
    private final HistorialEstadoRepository historialEstadoRepository;

    private static final EnumMap<EstadoTrabajo, Set<EstadoTrabajo>> TRANSICIONES = new EnumMap<>(EstadoTrabajo.class);
    private static final Set<EstadoTrabajo> FINALES = EnumSet.of(EstadoTrabajo.ENTREGADO, EstadoTrabajo.CANCELADO);

    static {
        TRANSICIONES.put(EstadoTrabajo.CREADO, EnumSet.of(EstadoTrabajo.EN_PROGRESO, EstadoTrabajo.CANCELADO));
        TRANSICIONES.put(EstadoTrabajo.EN_PROGRESO, EnumSet.of(EstadoTrabajo.EN_REVISION, EstadoTrabajo.CANCELADO));
        TRANSICIONES.put(EstadoTrabajo.EN_REVISION, EnumSet.of(EstadoTrabajo.EN_PROGRESO, EstadoTrabajo.ENTREGADO));
    }

    public TrabajoService(
            AuthUserProvider authUserProvider,
            PermissionService permissionService,
            TrabajoRepository trabajoRepository,
            UsuarioRepository usuarioRepository,
            TrabajoParticipanteRepository trabajoParticipanteRepository,
            RequisitoRepository requisitoRepository,
            ComentarioRepository comentarioRepository,
            HistorialEstadoRepository historialEstadoRepository) {
        this.authUserProvider = authUserProvider;
        this.permissionService = permissionService;
        this.trabajoRepository = trabajoRepository;
        this.usuarioRepository = usuarioRepository;
        this.trabajoParticipanteRepository = trabajoParticipanteRepository;
        this.requisitoRepository = requisitoRepository;
        this.comentarioRepository = comentarioRepository;
        this.historialEstadoRepository = historialEstadoRepository;
    }

    // =========================
    // 1) CREAR TRABAJO (ADMIN)
    // =========================
    @Transactional
    public TrabajoDetailResponse crearTrabajo(TrabajoCreateRequest request) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdmin(auth);

        Trabajo t = new Trabajo();
        t.setTitulo(request.titulo());
        t.setCliente(request.cliente());
        t.setDescripcion(request.descripcion());
        t.setPrioridad(request.prioridad());
        t.setFechaInicio(LocalDateTime.now().toLocalDate());
        t.setFechaFin(request.fechaFin());
        t.setEstadoActual(EstadoTrabajo.CREADO);
        t.setCreadoPor(auth);

        trabajoRepository.save(t);

        // Regla: el creador queda como participante ADMIN del trabajo
        TrabajoParticipante tpAdmin = new TrabajoParticipante();
        tpAdmin.setId(new TrabajoParticipanteId(t.getId(), auth.getId()));
        tpAdmin.setTrabajo(t);
        tpAdmin.setUsuario(auth);
        tpAdmin.setRolEnTrabajo(auth.getRol()); // normalmente Rol.ADMIN
        trabajoParticipanteRepository.save(tpAdmin);

        // Participantes adicionales (si vienen)
        if (request.participantes() != null) {
            for (ParticipanteRequest p : request.participantes()) {
                Usuario u = usuarioRepository.findById(p.usuarioId())
                        .orElseThrow(() -> new RuntimeException("Usuario no existe: " + p.usuarioId()));

                // opcional: evitar duplicar al creador
                if (u.getId().equals(auth.getId())) continue;

                TrabajoParticipante tp = new TrabajoParticipante();
                tp.setId(new TrabajoParticipanteId(t.getId(), u.getId()));
                tp.setTrabajo(t);
                tp.setUsuario(u);
                tp.setRolEnTrabajo(p.rolEnTrabajo());
                trabajoParticipanteRepository.save(tp);
            }
        }

        // Requisitos (si vienen)
        if (request.requisitos() != null) {
            for (var r : request.requisitos()) {
                Requisito req = new Requisito();
                req.setTrabajo(t);
                req.setDescripcion(r.descripcion());
                req.setAdjuntoUrl(r.adjuntoUrl());
                requisitoRepository.save(req);
            }
        }

        return buildDetalle(t.getId());
    }

    // =========================
    // 2) LISTAR MIS TRABAJOS
    // =========================
    public List<TrabajoListItemResponse> listarMisTrabajos() {
        Usuario auth = authUserProvider.getAuthUser();

        // Usamos tu repo actual sin tocar TrabajoRepository:
        // tpRepo.findByUsuario_Id(...) y mapeamos a trabajos
        return trabajoParticipanteRepository.findByUsuario_Id(auth.getId()).stream()
                .map(TrabajoParticipante::getTrabajo)
                .distinct()
                .map(TrabajoMapper::toListItem)
                .toList();
    }

    // =========================
    // 3) DETALLE TRABAJO
    // ADMIN o PARTICIPANTE
    // =========================
    public TrabajoDetailResponse detalleTrabajo(Long trabajoId) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdminOrParticipante(trabajoId, auth);

        return buildDetalle(trabajoId);
    }

    // =========================
    // 4) CAMBIAR ESTADO + HISTORIAL
    // =========================
    @Transactional
    public void cambiarEstado(Long trabajoId, CambiarEstadoRequest req) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdminOrParticipante(trabajoId, auth);

        Trabajo t = trabajoRepository.findById(trabajoId)
                .orElseThrow(() -> new RuntimeException("Trabajo no existe: " + trabajoId));

        EstadoTrabajo actual = t.getEstadoActual();
        EstadoTrabajo nuevo = req.nuevoEstado();

        if (FINALES.contains(actual)) {
            throw new RuntimeException("No se puede cambiar estado: trabajo en estado final (" + actual + ")");
        }

        Set<EstadoTrabajo> permitidos = TRANSICIONES.getOrDefault(actual, Set.of());
        if (!permitidos.contains(nuevo)) {
            throw new RuntimeException("Transición no permitida: " + actual + " -> " + nuevo);
        }

        t.setEstadoActual(nuevo);
        trabajoRepository.save(t);

        HistorialEstado h = new HistorialEstado();
        h.setTrabajo(t);
        h.setUsuario(auth);
        h.setEstado(nuevo);
        h.setFecha(LocalDateTime.now());
        h.setMotivo(req.motivo());
        historialEstadoRepository.save(h);
    }

    // =========================
    // Helper: construir detalle completo (RF13)
    // =========================
    private TrabajoDetailResponse buildDetalle(Long trabajoId) {
        Trabajo t = trabajoRepository.findById(trabajoId)
                .orElseThrow(() -> new RuntimeException("Trabajo no existe: " + trabajoId));

        var participantes = trabajoParticipanteRepository.findByTrabajo_Id(trabajoId);
        var requisitos = requisitoRepository.findByTrabajo_Id(trabajoId);
        var comentarios = comentarioRepository.findByTrabajo_IdOrderByFechaAsc(trabajoId);
        var historial = historialEstadoRepository.findByTrabajo_IdOrderByFechaAsc(trabajoId);

        return TrabajoMapper.toDetail(t, participantes, requisitos, comentarios, historial);
    }
}