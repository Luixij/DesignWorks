package com.designworks.backend.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.designworks.backend.entities.Requisito;

public interface RequisitoRepository extends JpaRepository<Requisito, Long> {

    List<Requisito> findByTrabajo_Id(Long trabajoId);
}