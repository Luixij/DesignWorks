package com.designworks.backend.controllers;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.response.HistorialEstadoResponse;
import com.designworks.backend.services.HistorialService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/trabajos/{trabajoId}/historial")
@Tag(name = "Historial", description = "Consulta del historial de estados de un trabajo")
public class HistorialController {

    private final HistorialService historialService;

    public HistorialController(HistorialService historialService) {
        this.historialService = historialService;
    }

    // GET historial → ADMIN o si participa
    @Operation(summary = "Listar historial de estados", description = "Devuelve el historial de cambios de estado de un trabajo. ADMIN o participante.")
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#trabajoId)")
    @GetMapping
    public List<HistorialEstadoResponse> listar(@PathVariable Long trabajoId) {
        return historialService.listarHistorial(trabajoId);
    }
}