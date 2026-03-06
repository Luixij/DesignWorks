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

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/trabajos")
@Tag(name = "Trabajos", description = "Gestión de trabajos y cambios de estado")
public class TrabajoController {

    private final TrabajoService trabajoService;

    public TrabajoController(TrabajoService trabajoService) {
        this.trabajoService = trabajoService;
    }

    // POST /trabajos → solo ADMIN
    @Operation(summary = "Crear trabajo", description = "Crea un nuevo trabajo. Solo ADMIN.")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public TrabajoDetailResponse crear(@RequestBody TrabajoCreateRequest req) {
        return trabajoService.crearTrabajo(req);
    }

    // GET /trabajos → solo ADMIN (listar todos los trabajos)
    @Operation(summary = "Listar todos los trabajos", description = "Devuelve todos los trabajos. Solo ADMIN.")
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public List<TrabajoListItemResponse> listarTodos() {
        return trabajoService.listarTodos();
    }

    // GET /trabajos/mis → ADMIN o DISEÑADOR
    @Operation(summary = "Listar mis trabajos", description = "Devuelve los trabajos del usuario autenticado. ADMIN o DISENADOR.")
    @PreAuthorize("hasAnyRole('ADMIN','DISENADOR')")
    @GetMapping("/mis")
    public List<TrabajoListItemResponse> mis() {
        return trabajoService.listarMisTrabajos();
    }

    // GET /trabajos/{id} → ADMIN o si participa
    @Operation(summary = "Obtener detalle de un trabajo", description = "Devuelve el detalle de un trabajo. ADMIN o participante.")
    @PreAuthorize("(hasRole('ADMIN')) or (@trabajoAuthz.esParticipante(#id))")
    @GetMapping("/{id}")
    public TrabajoDetailResponse detalle(@PathVariable Long id) {
        return trabajoService.detalleTrabajo(id);
    }

    // PUT /trabajos/{id}/estado → ADMIN o si participa
    @Operation(summary = "Cambiar estado de un trabajo", description = "Actualiza el estado del trabajo. ADMIN o participante.")
    @PreAuthorize("(hasRole('ADMIN')) or (@trabajoAuthz.esParticipante(#id))")
    @PutMapping("/{id}/estado")
    public void cambiarEstado(@PathVariable Long id, @RequestBody CambiarEstadoRequest req) {
        trabajoService.cambiarEstado(id, req);
    }

}