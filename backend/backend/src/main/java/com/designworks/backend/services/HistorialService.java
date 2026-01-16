package com.designworks.backend.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.designworks.backend.dto.TrabajoMapper;
import com.designworks.backend.dto.response.HistorialEstadoResponse;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.HistorialEstadoRepository;
import com.designworks.backend.security.AuthUserProvider;

@Service
public class HistorialService {

    private final AuthUserProvider authUserProvider;
    private final PermissionService permissionService;
    private final HistorialEstadoRepository historialEstadoRepository;

    public HistorialService(
            AuthUserProvider authUserProvider,
            PermissionService permissionService,
            HistorialEstadoRepository historialEstadoRepository) {
        this.authUserProvider = authUserProvider;
        this.permissionService = permissionService;
        this.historialEstadoRepository = historialEstadoRepository;
    }

    public List<HistorialEstadoResponse> listarHistorial(Long trabajoId) {
        Usuario auth = authUserProvider.getAuthUser();
        permissionService.requireAdminOrParticipante(trabajoId, auth);

        return historialEstadoRepository.findByTrabajo_IdOrderByFechaAsc(trabajoId).stream()
                .map(TrabajoMapper::toHistorial)
                .toList();
    }
}