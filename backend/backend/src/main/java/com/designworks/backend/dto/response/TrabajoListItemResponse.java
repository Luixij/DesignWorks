package com.designworks.backend.dto.response;

import java.time.LocalDate;

import com.designworks.backend.entities.enums.EstadoTrabajo;
import com.designworks.backend.entities.enums.Prioridad;

public record TrabajoListItemResponse(
        Long id,
        String titulo,
        String cliente,
        Prioridad prioridad,
        EstadoTrabajo estadoActual,
        LocalDate fechaInicio,
        LocalDate fechaFin
) {}