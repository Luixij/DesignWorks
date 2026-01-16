package com.designworks.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.designworks.backend.entities.Trabajo;

public interface TrabajoRepository extends JpaRepository<Trabajo, Long> {
    // findById y findAll(Pageable) ya existen
}
