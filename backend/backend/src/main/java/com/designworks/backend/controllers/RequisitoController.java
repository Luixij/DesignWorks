package com.designworks.backend.controllers;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.request.RequisitoCreateRequest;
import com.designworks.backend.dto.response.RequisitoResponse;
import com.designworks.backend.services.RequisitoService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/trabajos/{trabajoId}/requisitos")
@Tag(name = "Requisitos", description = "Gestión de requisitos o briefs asociados a trabajos")
public class RequisitoController {

    private final RequisitoService requisitoService;

    public RequisitoController(RequisitoService requisitoService) {
        this.requisitoService = requisitoService;
    }

    // POST requisito → solo ADMIN (aunque ya lo controles en service, mejor “doble
    // candado”)
    @Operation(summary = "Crear requisito", description = "Añade un requisito a un trabajo. Solo ADMIN.")
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public RequisitoResponse add(@PathVariable Long trabajoId, @RequestBody RequisitoCreateRequest req) {
        return requisitoService.addRequisito(trabajoId, req);
    }

    // GET requisitos → ADMIN o si participa
    @Operation(summary = "Listar requisitos", description = "Devuelve los requisitos de un trabajo. ADMIN o participante.")
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#trabajoId)")
    @GetMapping
    public List<RequisitoResponse> listar(@PathVariable Long trabajoId) {
        return requisitoService.listar(trabajoId);
    }
}