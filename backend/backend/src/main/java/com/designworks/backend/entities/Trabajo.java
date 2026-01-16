package com.designworks.backend.entities;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import com.designworks.backend.entities.enums.EstadoTrabajo;
import com.designworks.backend.entities.enums.Prioridad;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "trabajos")
public class Trabajo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(nullable = false, length = 150)
    private String cliente;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Prioridad prioridad;

    private LocalDate fechaInicio;
    private LocalDate fechaFin;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EstadoTrabajo estadoActual;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "creado_por_id", nullable = false)
    private Usuario creadoPor;

    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, orphanRemoval = true)
    private final List<Comentario> comentarios = new ArrayList<>();

    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, orphanRemoval = true)
    private final List<Requisito> requisitos = new ArrayList<>();

    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, orphanRemoval = true)
    private final List<HistorialEstado> historialEstados = new ArrayList<>();

    public Trabajo() {
    }

    // -------------------------
    // Getters / Setters
    // -------------------------

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public Prioridad getPrioridad() {
        return prioridad;
    }

    public void setPrioridad(Prioridad prioridad) {
        this.prioridad = prioridad;
    }

    public LocalDate getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDate fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }

    public EstadoTrabajo getEstadoActual() {
        return estadoActual;
    }

    public void setEstadoActual(EstadoTrabajo estadoActual) {
        this.estadoActual = estadoActual;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Usuario getCreadoPor() {
        return creadoPor;
    }

    public void setCreadoPor(Usuario creadoPor) {
        this.creadoPor = creadoPor;
    }

    public List<Comentario> getComentarios() {
        return comentarios;
    }

    public List<Requisito> getRequisitos() {
        return requisitos;
    }

    public List<HistorialEstado> getHistorialEstados() {
        return historialEstados;
    }

    // -------------------------
    // Helpers (relaciones)
    // -------------------------

    public void addComentario(Comentario comentario) {
        if (comentario == null)
            return;
        comentarios.add(comentario);
        comentario.setTrabajo(this);
    }

    public void removeComentario(Comentario comentario) {
        if (comentario == null)
            return;
        comentarios.remove(comentario);
        comentario.setTrabajo(null);
    }

    public void addRequisito(Requisito requisito) {
        if (requisito == null)
            return;
        requisitos.add(requisito);
        requisito.setTrabajo(this);
    }

    public void removeRequisito(Requisito requisito) {
        if (requisito == null)
            return;
        requisitos.remove(requisito);
        requisito.setTrabajo(null);
    }

    public void addHistorialEstado(HistorialEstado historial) {
        if (historial == null)
            return;
        historialEstados.add(historial);
        historial.setTrabajo(this);
    }

    public void removeHistorialEstado(HistorialEstado historial) {
        if (historial == null)
            return;
        historialEstados.remove(historial);
        historial.setTrabajo(null);
    }

    public void changeStatus(EstadoTrabajo newStatus, Usuario user, String reason) {
        Objects.requireNonNull(newStatus, "newStatus cannot be null");
        Objects.requireNonNull(user, "user cannot be null");

        // Avoid creating duplicated history if status is the same
        if (this.estadoActual == newStatus) {
            return;
        }

        // 1. Update current status
        this.estadoActual = newStatus;

        // 2. Create history record
        HistorialEstado history = new HistorialEstado();
        history.setEstado(newStatus);
        history.setUsuario(user);
        history.setFecha(LocalDateTime.now());
        history.setMotivo(reason);

        // 3. Link bidirectionally
        this.addHistorialEstado(history);
    }
}