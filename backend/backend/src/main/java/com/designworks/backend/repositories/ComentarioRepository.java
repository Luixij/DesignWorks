package com.designworks.backend.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.designworks.backend.entities.Comentario;

public interface ComentarioRepository extends JpaRepository<Comentario, Long> {

    List<Comentario> findByTrabajo_IdOrderByFechaAsc(Long trabajoId);
}