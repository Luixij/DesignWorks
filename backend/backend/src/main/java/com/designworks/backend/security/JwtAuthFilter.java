package com.designworks.backend.security;

import java.io.IOException;
import java.util.Collection;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final CustomUserDetailsService userDetailsService;

    public JwtAuthFilter(JwtService jwtService, CustomUserDetailsService userDetailsService) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
    }

    /** Principal enriquecido con uid, pero compatible con UserDetails */
    public static class AuthUser implements UserDetails {
        private final Long uid;
        private final UserDetails delegate;

        public AuthUser(Long uid, UserDetails delegate) {
            this.uid = uid;
            this.delegate = delegate;
        }

        public Long getUid() { return uid; }

        @Override public Collection<? extends GrantedAuthority> getAuthorities() { return delegate.getAuthorities(); }
        @Override public String getPassword() { return delegate.getPassword(); }
        @Override public String getUsername() { return delegate.getUsername(); }
        @Override public boolean isAccountNonExpired() { return delegate.isAccountNonExpired(); }
        @Override public boolean isAccountNonLocked() { return delegate.isAccountNonLocked(); }
        @Override public boolean isCredentialsNonExpired() { return delegate.isCredentialsNonExpired(); }
        @Override public boolean isEnabled() { return delegate.isEnabled(); }
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            chain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        try {
            Claims claims = jwtService.parseClaims(token);

            String email = claims.getSubject(); // sub
            Object uidObj = claims.get("uid");

            Long uid = null;
            if (uidObj instanceof Number n) uid = n.longValue();
            else if (uidObj instanceof String s) {
                try { uid = Long.parseLong(s); } catch (NumberFormatException ignored) {}
            }

            if (email == null || email.isBlank()) {
                chain.doFilter(request, response);
                return;
            }

            var existing = SecurityContextHolder.getContext().getAuthentication();
            if (existing != null && !(existing instanceof AnonymousAuthenticationToken)) {
                chain.doFilter(request, response);
                return;
            }

            UserDetails ud = userDetailsService.loadUserByUsername(email);
            AuthUser principal = new AuthUser(uid, ud);

            var authToken = new UsernamePasswordAuthenticationToken(
                    principal, null, principal.getAuthorities()
            );
            authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authToken);

        } catch (ExpiredJwtException | MalformedJwtException | UnsupportedJwtException | SignatureException
                | IllegalArgumentException ex) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        chain.doFilter(request, response);
    }
}
