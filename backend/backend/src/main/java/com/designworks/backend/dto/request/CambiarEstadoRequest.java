package com.designworks.backend.dto.request;

import com.designworks.backend.entities.enums.EstadoTrabajo;

public record CambiarEstadoRequest(
        EstadoTrabajo nuevoEstado,
        String motivo
) {}