package com.designworks.backend.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.designworks.backend.entities.TrabajoParticipante;
import com.designworks.backend.entities.TrabajoParticipanteId;

public interface TrabajoParticipanteRepository extends JpaRepository<TrabajoParticipante, TrabajoParticipanteId> {

    List<TrabajoParticipante> findByUsuario_Id(Long usuarioId);

    boolean existsByTrabajo_IdAndUsuario_Id(Long trabajoId, Long usuarioId);
}