package com.designworks.backend.dto.request;

import java.time.LocalDate;
import java.util.List;

import com.designworks.backend.entities.enums.Prioridad;

public record TrabajoCreateRequest(
        String titulo,
        String cliente,
        String descripcion,
        Prioridad prioridad,
        LocalDate fechaFin,
        List<ParticipanteRequest> participantes,
        List<RequisitoCreateRequest> requisitos
) {}