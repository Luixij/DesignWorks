package com.designworks.backend.dto;

public record LoginResponse(
        String token,
        String rol
) {}