package com.designworks.backend.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.request.ComentarioCreateRequest;
import com.designworks.backend.dto.response.ComentarioResponse;
import com.designworks.backend.services.ComentarioService;

@RestController
@RequestMapping("/trabajos/{trabajoId}/comentarios")
public class ComentarioController {

    private final ComentarioService comentarioService;

    public ComentarioController(ComentarioService comentarioService) {
        this.comentarioService = comentarioService;
    }

    @PostMapping
    public ComentarioResponse crear(@PathVariable Long trabajoId, @RequestBody ComentarioCreateRequest req) {
        return comentarioService.crearComentario(trabajoId, req);
    }

    @GetMapping
    public List<ComentarioResponse> listar(@PathVariable Long trabajoId) {
        return comentarioService.listar(trabajoId);
    }
}