package com.designworks.backend.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.designworks.backend.repositories.TrabajoRepository;

@Component("trabajoAuthz")
public class TrabajoAuthz {

    private final TrabajoRepository trabajoRepository;

    public TrabajoAuthz(TrabajoRepository trabajoRepository) {
        this.trabajoRepository = trabajoRepository;
    }

    public boolean esParticipante(Long trabajoId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return false;

        String email = auth.getName(); // en tu proyecto es el email
        return trabajoRepository.existsByIdAndCreadoPorEmail(trabajoId, email);
    }
}