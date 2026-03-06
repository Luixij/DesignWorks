package com.designworks.backend.controllers;

import java.security.Principal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.designworks.backend.dto.LoginRequest;
import com.designworks.backend.dto.LoginResponse;
import com.designworks.backend.dto.response.UsuarioBasicResponse;
import com.designworks.backend.services.AuthService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/auth")
@Tag(name = "Autenticación", description = "Operaciones de autenticación y consulta del usuario autenticado")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /**
     * Endpoint de login
     * POST /auth/login
     */
    @Operation(summary = "Iniciar sesión", description = "Autentica al usuario y devuelve el token JWT")
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest req) {
        return ResponseEntity.ok(authService.login(req));
    }

    /**
     * Endpoint para obtener información del usuario autenticado
     * GET /auth/me
     * 
     * Requiere: Authorization header con Bearer token
     * 
     * @param principal Objeto que contiene el email del usuario autenticado
     *                  (extraído automáticamente del JWT por Spring Security)
     * @return Información básica del usuario (id, nombre, email, rol)
     */
    @Operation(summary = "Obtener usuario autenticado", description = "Devuelve la información básica del usuario autenticado a partir del JWT")
    @GetMapping("/me")
    public ResponseEntity<UsuarioBasicResponse> getCurrentUser(Principal principal) {
        if (principal == null)
            return ResponseEntity.status(401).build();
        return ResponseEntity.ok(authService.getCurrentUser(principal.getName()));
    }
}