package com.designworks.backend.dto.response;

import java.time.LocalDate;
import java.util.List;

import com.designworks.backend.entities.enums.EstadoTrabajo;
import com.designworks.backend.entities.enums.Prioridad;

public record TrabajoDetailResponse(
        Long id,
        String titulo,
        String cliente,
        String descripcion,
        Prioridad prioridad,
        EstadoTrabajo estadoActual,
        LocalDate fechaInicio,
        LocalDate fechaFin,
        UsuarioBasicResponse creadoPor,
        List<ParticipanteResponse> participantes,
        List<RequisitoResponse> requisitos,
        List<ComentarioResponse> comentarios,
        List<HistorialEstadoResponse> historial
) {}