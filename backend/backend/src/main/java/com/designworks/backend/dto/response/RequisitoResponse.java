package com.designworks.backend.dto.response;

public record RequisitoResponse(
        Long id,
        String descripcion,
        String adjuntoUrl
) {}