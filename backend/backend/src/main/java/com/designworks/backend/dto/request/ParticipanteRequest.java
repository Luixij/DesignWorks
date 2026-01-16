package com.designworks.backend.dto.request;

import com.designworks.backend.entities.Rol;

public record ParticipanteRequest(
        Long usuarioId,
        Rol rolEnTrabajo
) {}