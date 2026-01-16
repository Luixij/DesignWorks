package com.designworks.backend.controllers;

import java.util.List;

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

    @PostMapping
    public TrabajoDetailResponse crear(@RequestBody TrabajoCreateRequest req) {
        return trabajoService.crearTrabajo(req);
    }

    @GetMapping("/mis")
    public List<TrabajoListItemResponse> mis() {
        return trabajoService.listarMisTrabajos();
    }

    @GetMapping("/{id}")
    public TrabajoDetailResponse detalle(@PathVariable Long id) {
        return trabajoService.detalleTrabajo(id);
    }

    @PutMapping("/{id}/estado")
    public void cambiarEstado(@PathVariable Long id, @RequestBody CambiarEstadoRequest req) {
        trabajoService.cambiarEstado(id, req);
    }
}