package com.designworks.backend.dto.response;

import java.time.LocalDateTime;

public record ComentarioResponse(
        Long id,
        String texto,
        LocalDateTime fecha,
        UsuarioBasicResponse usuario
) {}