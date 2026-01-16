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

@RestController
@RequestMapping("/trabajos/{trabajoId}/requisitos")
public class RequisitoController {

    private final RequisitoService requisitoService;

    public RequisitoController(RequisitoService requisitoService) {
        this.requisitoService = requisitoService;
    }

    // POST requisito → solo ADMIN (aunque ya lo controles en service, mejor “doble
    // candado”)
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public RequisitoResponse add(@PathVariable Long trabajoId, @RequestBody RequisitoCreateRequest req) {
        return requisitoService.addRequisito(trabajoId, req);
    }

    // GET requisitos → ADMIN o si participa
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#trabajoId)")
    @GetMapping
    public List<RequisitoResponse> listar(@PathVariable Long trabajoId) {
        return requisitoService.listar(trabajoId);
    }
}