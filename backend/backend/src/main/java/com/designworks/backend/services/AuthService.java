package com.designworks.backend.services;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

import com.designworks.backend.dto.LoginRequest;
import com.designworks.backend.dto.LoginResponse;
import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.UsuarioRepository;
import com.designworks.backend.security.JwtService;

@Service
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final UsuarioRepository usuarioRepository;
    private final JwtService jwtService;

    public AuthService(AuthenticationManager authenticationManager,
            UsuarioRepository usuarioRepository,
            JwtService jwtService) {
        this.authenticationManager = authenticationManager;
        this.usuarioRepository = usuarioRepository;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest req) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.email(), req.password()));

        // Si autentica, buscamos usuario para sacar id y rol
        Usuario u = usuarioRepository.findByEmail(req.email())
                .orElseThrow(() -> new BadCredentialsException("Credenciales inválidas"));

        String token = jwtService.generateToken(u.getId(), u.getEmail(), u.getRol());
        return new LoginResponse(token, u.getRol().name());
    }
}