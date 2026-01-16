package com.designworks.backend.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.designworks.backend.dto.TrabajoMapper;
import com.designworks.backend.dto.request.RequisitoCreateRequest;
import com.designworks.backend.dto.response.RequisitoResponse;
import com.designworks.backend.entities.Requisito;
import com.designworks.backend.entities.Trabajo;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.RequisitoRepository;
import com.designworks.backend.repositories.TrabajoRepository;
import com.designworks.backend.security.AuthUserProvider;

@Service
public class RequisitoService {

    private final AuthUserProvider authUserProvider;
    private final PermissionService permissionService;

    private final TrabajoRepository trabajoRepository;
    private final RequisitoRepository requisitoRepository;

    public RequisitoService(
            AuthUserProvider authUserProvider,
            PermissionService permissionService,
            TrabajoRepository trabajoRepository,
            RequisitoRepository requisitoRepository) {
        this.authUserProvider = authUserProvider;
        this.permissionService = permissionService;
        this.trabajoRepository = trabajoRepository;
        this.requisitoRepository = requisitoRepository;
    }

    public RequisitoResponse addRequisito(Long trabajoId, RequisitoCreateRequest req) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdmin(auth);

        Trabajo t = trabajoRepository.findById(trabajoId)
                .orElseThrow(() -> new RuntimeException("Trabajo no existe: " + trabajoId));

        Requisito r = new Requisito();
        r.setTrabajo(t);
        r.setDescripcion(req.descripcion());
        r.setAdjuntoUrl(req.adjuntoUrl());
        requisitoRepository.save(r);

        return TrabajoMapper.toRequisito(r);
    }

    public List<RequisitoResponse> listar(Long trabajoId) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdminOrParticipante(trabajoId, auth);

        return requisitoRepository.findByTrabajo_Id(trabajoId).stream()
                .map(TrabajoMapper::toRequisito)
                .toList();
    }
}