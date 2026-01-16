package com.designworks.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.designworks.backend.entities.Trabajo;

public interface TrabajoRepository extends JpaRepository<Trabajo, Long> {

    boolean existsByIdAndCreadoPorEmail(Long id, String email);
}