package com.designworks.backend.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.designworks.backend.dto.TrabajoMapper;
import com.designworks.backend.dto.request.ComentarioCreateRequest;
import com.designworks.backend.dto.response.ComentarioResponse;
import com.designworks.backend.entities.Comentario;
import com.designworks.backend.entities.Trabajo;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.ComentarioRepository;
import com.designworks.backend.repositories.TrabajoRepository;
import com.designworks.backend.security.AuthUserProvider;

@Service
public class ComentarioService {

    private final AuthUserProvider authUserProvider;
    private final PermissionService permissionService;

    private final TrabajoRepository trabajoRepository;
    private final ComentarioRepository comentarioRepository;

    public ComentarioService(
            AuthUserProvider authUserProvider,
            PermissionService permissionService,
            TrabajoRepository trabajoRepository,
            ComentarioRepository comentarioRepository) {
        this.authUserProvider = authUserProvider;
        this.permissionService = permissionService;
        this.trabajoRepository = trabajoRepository;
        this.comentarioRepository = comentarioRepository;
    }

    public ComentarioResponse crearComentario(Long trabajoId, ComentarioCreateRequest req) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdminOrParticipante(trabajoId, auth);

        Trabajo t = trabajoRepository.findById(trabajoId)
                .orElseThrow(() -> new RuntimeException("Trabajo no existe: " + trabajoId));

        Comentario c = new Comentario();
        c.setTrabajo(t);
        c.setUsuario(auth);
        c.setTexto(req.texto());
        c.setFecha(LocalDateTime.now());

        comentarioRepository.save(c);
        return TrabajoMapper.toComentario(c);
    }

    public List<ComentarioResponse> listar(Long trabajoId) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdminOrParticipante(trabajoId, auth);

        return comentarioRepository.findByTrabajo_IdOrderByFechaAsc(trabajoId).stream()
                .map(TrabajoMapper::toComentario)
                .toList();
    }
}