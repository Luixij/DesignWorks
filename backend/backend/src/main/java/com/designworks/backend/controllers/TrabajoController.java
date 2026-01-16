package com.designworks.backend.controllers;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.request.CambiarEstadoRequest;
import com.designworks.backend.dto.request.TrabajoCreateRequest;
import com.designworks.backend.dto.response.TrabajoDetailResponse;
import com.designworks.backend.dto.response.TrabajoListItemResponse;
import com.designworks.backend.services.TrabajoService;

@RestController
@RequestMapping("/trabajos")
public class TrabajoController {

    private final TrabajoService trabajoService;

    public TrabajoController(TrabajoService trabajoService) {
        this.trabajoService = trabajoService;
    }

        // POST /trabajos → solo ADMIN
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public TrabajoDetailResponse crear(@RequestBody TrabajoCreateRequest req) {
        return trabajoService.crearTrabajo(req);
    }

    
    // GET /trabajos/mis → ADMIN o DISEÑADOR
    @PreAuthorize("hasAnyRole('ADMIN','DISENADOR')")
    @GetMapping("/mis")
    public List<TrabajoListItemResponse> mis() {
        return trabajoService.listarMisTrabajos();
    }

    // GET /trabajos/{id} → ADMIN o si participa
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#id)")
    @GetMapping("/{id}")
    public TrabajoDetailResponse detalle(@PathVariable Long id) {
        return trabajoService.detalleTrabajo(id);
    }

    
    // PUT /trabajos/{id}/estado → ADMIN o si participa
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#id)")
    @PutMapping("/{id}/estado")
    public void cambiarEstado(@PathVariable Long id, @RequestBody CambiarEstadoRequest req) {
        trabajoService.cambiarEstado(id, req);
    }
}