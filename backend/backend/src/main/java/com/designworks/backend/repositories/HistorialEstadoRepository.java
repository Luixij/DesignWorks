package com.designworks.backend.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.designworks.backend.entities.HistorialEstado;

public interface HistorialEstadoRepository extends JpaRepository<HistorialEstado, Long> {

    List<HistorialEstado> findByTrabajo_IdOrderByFechaAsc(Long trabajoId);
}