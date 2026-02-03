package com.designworks.backend.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.designworks.backend.repositories.TrabajoParticipanteRepository;
import com.designworks.backend.repositories.TrabajoRepository;

@Component("trabajoAuthz")
public class TrabajoAuthz {

    private static final Logger log = LoggerFactory.getLogger(TrabajoAuthz.class);

    private final TrabajoRepository trabajoRepository;
    private final TrabajoParticipanteRepository trabajoParticipanteRepository;

    public TrabajoAuthz(TrabajoRepository trabajoRepository,
                        TrabajoParticipanteRepository trabajoParticipanteRepository) {
        this.trabajoRepository = trabajoRepository;
        this.trabajoParticipanteRepository = trabajoParticipanteRepository;
    }

    /**
     * Verifica si el usuario autenticado es participante del trabajo especificado.
     * Se usa en @PreAuthorize para control de acceso.
     */
    public boolean esParticipante(Long trabajoId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || auth instanceof AnonymousAuthenticationToken) {
            return false;
        }

        Long uid = null;
        String email = null;
        Object principal = auth.getPrincipal();

        // Extraer UID y email del principal
        if (principal instanceof JwtAuthFilter.AuthUser au) {
            uid = au.getUid();
            email = au.getUsername();
        } else if (principal instanceof org.springframework.security.core.userdetails.UserDetails ud) {
            email = ud.getUsername();
        } else {
            email = auth.getName();
        }

        // 1) Verificación por UID (método más eficiente)
        if (uid != null) {
            if (trabajoParticipanteRepository.existsByTrabajo_IdAndUsuario_Id(trabajoId, uid)) {
                return true;
            }
        }

        // 2) Fallback por email
        if (email != null && !email.isBlank()) {
            // Verificar si es creador
            if (trabajoRepository.existsByIdAndCreadoPorEmail(trabajoId, email)) {
                return true;
            }
            // Verificar si es participante
            if (trabajoRepository.existsByIdAndParticipantesEmail(trabajoId, email)) {
                return true;
            }
        }

        log.debug("Acceso denegado - trabajoId={}, uid={}, email={}", trabajoId, uid, email);
        return false;
    }
}