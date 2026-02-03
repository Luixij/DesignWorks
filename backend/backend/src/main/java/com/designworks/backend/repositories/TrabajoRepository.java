package com.designworks.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.designworks.backend.entities.Trabajo;

public interface TrabajoRepository extends JpaRepository<Trabajo, Long> {

    /**
     * True si el trabajo existe y fue creado por el usuario con ese email.
     */
    boolean existsByIdAndCreadoPorEmail(Long id, String email);

    /**
     * True si el usuario con ese email está asignado como participante al trabajo.
     * (Tabla: trabajo_participantes -> entidad: TrabajoParticipante)
     */
    @Query("""
        select case when count(tp) > 0 then true else false end
        from TrabajoParticipante tp
        where tp.trabajo.id = :trabajoId
          and tp.usuario.email = :email
    """)
    boolean existsByIdAndParticipantesEmail(
        @Param("trabajoId") Long trabajoId,
        @Param("email") String email
    );
}
