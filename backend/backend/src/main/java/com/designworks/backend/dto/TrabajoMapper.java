package com.designworks.backend.dto;

import java.util.List;

import com.designworks.backend.dto.response.ComentarioResponse;
import com.designworks.backend.dto.response.HistorialEstadoResponse;
import com.designworks.backend.dto.response.ParticipanteResponse;
import com.designworks.backend.dto.response.RequisitoResponse;
import com.designworks.backend.dto.response.TrabajoDetailResponse;
import com.designworks.backend.dto.response.TrabajoListItemResponse;
import com.designworks.backend.dto.response.UsuarioBasicResponse;
import com.designworks.backend.entities.Comentario;
import com.designworks.backend.entities.HistorialEstado;
import com.designworks.backend.entities.Requisito;
import com.designworks.backend.entities.Trabajo;
import com.designworks.backend.entities.TrabajoParticipante;
import com.designworks.backend.entities.Usuario;

public class TrabajoMapper {

    private TrabajoMapper() {
    }

    public static TrabajoListItemResponse toListItem(Trabajo t) {
        return new TrabajoListItemResponse(
                t.getId(),
                t.getTitulo(),
                t.getCliente(),
                t.getPrioridad(),
                t.getEstadoActual(),
                t.getFechaInicio(),
                t.getFechaFin());
    }

    public static TrabajoDetailResponse toDetail(
            Trabajo t,
            List<TrabajoParticipante> participantes,
            List<Requisito> requisitos,
            List<Comentario> comentarios,
            List<HistorialEstado> historial) {
        return new TrabajoDetailResponse(
                t.getId(),
                t.getTitulo(),
                t.getCliente(),
                t.getDescripcion(),
                t.getPrioridad(),
                t.getEstadoActual(),
                t.getFechaInicio(),
                t.getFechaFin(),
                toUsuarioBasic(t.getCreadoPor()),
                participantes.stream().map(TrabajoMapper::toParticipante).toList(),
                requisitos.stream().map(TrabajoMapper::toRequisito).toList(),
                comentarios.stream().map(TrabajoMapper::toComentario).toList(),
                historial.stream().map(TrabajoMapper::toHistorial).toList());
    }

    public static UsuarioBasicResponse toUsuarioBasic(Usuario u) {
        if (u == null)
            return null;
        return new UsuarioBasicResponse(u.getId(), u.getNombre(), u.getEmail(), u.getRol().name());
    }

    public static ParticipanteResponse toParticipante(TrabajoParticipante tp) {
        Usuario u = tp.getUsuario();
        return new ParticipanteResponse(
                u.getId(),
                u.getNombre(),
                u.getEmail(),
                tp.getRolEnTrabajo());
    }

    public static RequisitoResponse toRequisito(Requisito r) {
        return new RequisitoResponse(r.getId(), r.getDescripcion(), r.getAdjuntoUrl());
    }

    public static ComentarioResponse toComentario(Comentario c) {
        return new ComentarioResponse(
                c.getId(),
                c.getTexto(),
                c.getFecha(),
                toUsuarioBasic(c.getUsuario()));
    }

    public static HistorialEstadoResponse toHistorial(HistorialEstado h) {
        return new HistorialEstadoResponse(
                h.getId(),
                h.getEstado(),
                h.getFecha(),
                h.getMotivo(),
                toUsuarioBasic(h.getUsuario()));
    }
}