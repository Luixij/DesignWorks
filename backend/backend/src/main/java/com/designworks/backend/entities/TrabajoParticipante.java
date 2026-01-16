package com.designworks.backend.entities;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;

@Entity
@Table(name = "trabajo_participantes")
public class TrabajoParticipante {

    @EmbeddedId
    private TrabajoParticipanteId id = new TrabajoParticipanteId();

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId("trabajoId")
    @JoinColumn(name = "trabajo_id", nullable = false)
    private Trabajo trabajo;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId("usuarioId")
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "rol_en_trabajo", nullable = false, length = 80)
    private String rolEnTrabajo;

    public TrabajoParticipante() {}

    public TrabajoParticipanteId getId() { return id; }
    public void setId(TrabajoParticipanteId id) { this.id = id; }

    public Trabajo getTrabajo() { return trabajo; }
    public void setTrabajo(Trabajo trabajo) { this.trabajo = trabajo; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getRolEnTrabajo() { return rolEnTrabajo; }
    public void setRolEnTrabajo(String rolEnTrabajo) { this.rolEnTrabajo = rolEnTrabajo; }
}