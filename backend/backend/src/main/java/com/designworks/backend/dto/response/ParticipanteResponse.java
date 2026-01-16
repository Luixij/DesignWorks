package com.designworks.backend.dto.response;

import com.designworks.backend.entities.Rol;

public record ParticipanteResponse(
        Long usuarioId,
        String nombre,
        String email,
        Rol rolEnTrabajo
) {}