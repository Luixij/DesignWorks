package com.designworks.backend.entities;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Embeddable;

@Embeddable
public class TrabajoParticipanteId implements Serializable {

    private Long trabajoId;
    private Long usuarioId;

    public TrabajoParticipanteId() {}

    public TrabajoParticipanteId(Long trabajoId, Long usuarioId) {
        this.trabajoId = trabajoId;
        this.usuarioId = usuarioId;
    }

    public Long getTrabajoId() { return trabajoId; }
    public void setTrabajoId(Long trabajoId) { this.trabajoId = trabajoId; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TrabajoParticipanteId)) return false;
        TrabajoParticipanteId that = (TrabajoParticipanteId) o;
        return Objects.equals(trabajoId, that.trabajoId) &&
               Objects.equals(usuarioId, that.usuarioId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(trabajoId, usuarioId);
    }
}