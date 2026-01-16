package com.designworks.backend.services;

import org.springframework.stereotype.Service;

import com.designworks.backend.entities.Rol;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.TrabajoParticipanteRepository;

@Service
public class PermissionService {

    private final TrabajoParticipanteRepository trabajoParticipanteRepository;

    public PermissionService(TrabajoParticipanteRepository trabajoParticipanteRepository) {
        this.trabajoParticipanteRepository = trabajoParticipanteRepository;
    }

    public boolean isAdmin(Usuario u) {
        return u.getRol() == Rol.ADMIN;
    }

    public boolean isParticipante(Long trabajoId, Long usuarioId) {
        return trabajoParticipanteRepository.existsByTrabajo_IdAndUsuario_Id(trabajoId, usuarioId);
    }

    public void requireAdmin(Usuario u) {
        if (!isAdmin(u)) {
            throw new RuntimeException("Permiso denegado: requiere ADMIN");
        }
    }

    public void requireAdminOrParticipante(Long trabajoId, Usuario u) {
        if (isAdmin(u)) return;
        if (!isParticipante(trabajoId, u.getId())) {
            throw new RuntimeException("Permiso denegado: no participa en este trabajo");
        }
    }
}
