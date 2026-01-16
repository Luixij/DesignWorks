package com.designworks.backend.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.response.HistorialEstadoResponse;
import com.designworks.backend.services.HistorialService;

@RestController
@RequestMapping("/trabajos/{trabajoId}/historial")
public class HistorialController {

    private final HistorialService historialService;

    public HistorialController(HistorialService historialService) {
        this.historialService = historialService;
    }

    @GetMapping
    public List<HistorialEstadoResponse> listar(@PathVariable Long trabajoId) {
        return historialService.listarHistorial(trabajoId);
    }
}