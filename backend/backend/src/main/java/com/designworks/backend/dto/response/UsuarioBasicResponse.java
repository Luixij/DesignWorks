package com.designworks.backend.dto.response;

public record UsuarioBasicResponse(
        Long id,
        String nombre,
        String email,
        String rol
) {}