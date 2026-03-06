package com.designworks.backend.controllers;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.request.ComentarioCreateRequest;
import com.designworks.backend.dto.response.ComentarioResponse;
import com.designworks.backend.services.ComentarioService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/trabajos/{trabajoId}/comentarios")
@Tag(name = "Comentarios", description = "Gestión de comentarios asociados a trabajos")
public class ComentarioController {

    private final ComentarioService comentarioService;

    public ComentarioController(ComentarioService comentarioService) {
        this.comentarioService = comentarioService;
    }

    // POST comentarios → ADMIN o si participa
    @Operation(summary = "Crear comentario", description = "Añade un comentario a un trabajo. ADMIN o participante.")
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#trabajoId)")
    @PostMapping
    public ComentarioResponse crear(@PathVariable Long trabajoId, @RequestBody ComentarioCreateRequest req) {
        return comentarioService.crearComentario(trabajoId, req);
    }

    // GET comentarios → ADMIN o si participa
    @Operation(summary = "Listar comentarios", description = "Devuelve los comentarios de un trabajo. ADMIN o participante.")
    @PreAuthorize("hasRole('ADMIN') or @trabajoAuthz.esParticipante(#trabajoId)")
    @GetMapping
    public List<ComentarioResponse> listar(@PathVariable Long trabajoId) {
        return comentarioService.listar(trabajoId);
    }
}