package com.designworks.backend.dto.response;

import java.time.LocalDateTime;

import com.designworks.backend.entities.enums.EstadoTrabajo;

public record HistorialEstadoResponse(
        Long id,
        EstadoTrabajo estado,
        LocalDateTime fecha,
        String motivo,
        UsuarioBasicResponse usuario
) {}
