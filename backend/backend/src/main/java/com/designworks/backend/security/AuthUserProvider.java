package com.designworks.backend.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.designworks.backend.entities.Usuario;
import com.designworks.backend.repositories.UsuarioRepository;

@Component
public class AuthUserProvider {

    private final UsuarioRepository usuarioRepository;

    public AuthUserProvider(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    public Usuario getAuthUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName(); // normalmente "subject" del JWT

        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario autenticado no encontrado: " + email));
    }
}