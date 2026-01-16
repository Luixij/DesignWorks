package com.designworks.backend.controllers;

import java.util.List;

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

    @PostMapping
    public RequisitoResponse add(@PathVariable Long trabajoId, @RequestBody RequisitoCreateRequest req) {
        return requisitoService.addRequisito(trabajoId, req);
    }

    @GetMapping
    public List<RequisitoResponse> listar(@PathVariable Long trabajoId) {
        return requisitoService.listar(trabajoId);
    }
}